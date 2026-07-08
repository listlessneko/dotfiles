local M = {}

local QUERY_FILE = '/tmp/bqvd-query.sql'
local DRYRUN_FILE = '/tmp/bqvd-dryrun.sql'

local function get_lines(line1, line2)
  return vim.api.nvim_buf_get_lines(0, line1 - 1, line2, false)
end

local function human_bytes(bytes)
  local units = { 'B', 'KiB', 'MiB', 'GiB', 'TiB', 'PiB' }
  local size, idx = bytes, 1
  while size >= 1024 and idx < #units do
    size, idx = size / 1024, idx + 1
  end
  return string.format('%.2f %s', size, units[idx])
end

function M.run(line1, line2)
  local lines = get_lines(line1, line2)
  if table.concat(lines, '\n'):match('^%s*$') then
    vim.notify('bqvd: no query', vim.log.levels.WARN)
    return
  end
  vim.fn.writefile(lines, QUERY_FILE)
  vim.cmd('tabnew')
  local buf = vim.api.nvim_get_current_buf()
  vim.cmd('terminal bqvd < ' .. vim.fn.shellescape(QUERY_FILE))
  vim.b[buf].bqvd_running = true
  vim.cmd('startinsert')

  local refocus_id = vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter', 'FocusGained' }, {
    callback = function()
      if not vim.api.nvim_buf_is_valid(buf) then return end
      if vim.api.nvim_get_current_buf() ~= buf then return end
      if not vim.b[buf].bqvd_running then return end
      vim.schedule(function()
        if vim.api.nvim_get_current_buf() == buf and vim.b[buf].bqvd_running then
          vim.cmd('startinsert')
        end
      end)
    end,
  })

  vim.api.nvim_create_autocmd('TermClose', {
    buffer = buf,
    once = true,
    callback = function()
      local exit_code = vim.v.event.status
      vim.b[buf].bqvd_running = false
      pcall(vim.api.nvim_del_autocmd, refocus_id)
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(buf) then return end
        if exit_code == 0 then
          vim.api.nvim_buf_delete(buf, { force = true })
        else
          vim.cmd('stopinsert')
        end
      end)
    end,
  })
end

function M.dry_run(line1, line2)
  local lines = get_lines(line1, line2)
  if table.concat(lines, '\n'):match('^%s*$') then
    vim.notify('bqvd: no query', vim.log.levels.WARN)
    return
  end
  vim.fn.writefile(lines, DRYRUN_FILE)

  local args = { 'bq', 'query', '--dry_run', '--use_legacy_sql=false', '--format=json' }
  local project = os.getenv('BQVD_PROJECT')
  if project and project ~= '' then
    table.insert(args, '--project_id=' .. project)
  end

  vim.notify('bqvd: dry-running…', vim.log.levels.INFO)
  vim.system(args, { text = true, stdin = vim.fn.readfile(DRYRUN_FILE) }, function(obj)
    vim.schedule(function()
      if obj.code ~= 0 then
        local err = (obj.stderr or ''):gsub('%s+$', '')
        vim.notify('bqvd dry-run failed: ' .. (err ~= '' and err or 'exit ' .. obj.code), vim.log.levels.ERROR)
        return
      end
      local ok, parsed = pcall(vim.json.decode, obj.stdout or '')
      if not ok or not parsed then
        vim.notify('bqvd dry-run: could not parse output', vim.log.levels.ERROR)
        return
      end
      local job = (type(parsed) == 'table' and parsed[1]) or parsed
      local bytes_str = job and job.statistics and job.statistics.query
        and job.statistics.query.totalBytesProcessed
      local bytes = tonumber(bytes_str)
      if not bytes then
        vim.notify('bqvd dry-run: no totalBytesProcessed in response', vim.log.levels.ERROR)
        return
      end

      local price_per_tib = tonumber(os.getenv('BQVD_PRICE_PER_TIB')) or 6.25
      local cost = bytes / (1024 ^ 4) * price_per_tib
      local cost_str = (cost < 0.01) and '<$0.01' or string.format('$%.2f', cost)

      vim.notify(
        string.format('bqvd dry-run: %s · ~%s (upper bound)', human_bytes(bytes), cost_str),
        vim.log.levels.INFO
      )
    end)
  end)
end

vim.api.nvim_create_user_command('BqvdRun', function(opts)
  M.run(opts.line1, opts.line2)
end, { range = '%' })

vim.api.nvim_create_user_command('BqvdDryRun', function(opts)
  M.dry_run(opts.line1, opts.line2)
end, { range = '%' })

return M

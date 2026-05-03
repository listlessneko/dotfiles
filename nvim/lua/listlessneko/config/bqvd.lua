local M = {}

local QUERY_FILE = '/tmp/bqvd-query.sql'

local function get_lines(line1, line2)
  return vim.api.nvim_buf_get_lines(0, line1 - 1, line2, false)
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
  vim.cmd('startinsert')

  vim.api.nvim_create_autocmd('TermClose', {
    buffer = buf,
    once = true,
    callback = function()
      local exit_code = vim.v.event.status
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

vim.api.nvim_create_user_command('BqvdRun', function(opts)
  M.run(opts.line1, opts.line2)
end, { range = '%' })

return M

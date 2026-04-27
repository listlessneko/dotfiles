; extends

(switch_statement
  body: (compound_statement
    .
    "{"
    .
    (_) @_start @_end
    (_)? @_end
    .
    "}"
    (#make-range! "conditional.inner" @_start @_end))) @conditional.outer

(switch_statement) @conditional.outer

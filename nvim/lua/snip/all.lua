local ls = require"luasnip"
local s = ls.snippet
local t = ls.text_node
-- local i = ls.insert_node
-- local f = ls.function_node

local F = require"myfunc"

ls.add_snippets("all", {
  s("today", t(F.today('%Y%m%d')))
})


ls.add_snippets("bigquery", {
  s("init", t{
    [[#standardSQL]],
    string.format(
      "create temp function start_date() as (date '%s');",
      F.today('%Y-%m-%d')
    ),
    [[create temp function start_date_str(format string) as (]],
    "\tformat_date(format, start_date())",
    [[);]],
    string.format(
      "create temp function end_date() as (date '%s');",
      F.today('%Y-%m-%d')
    ),
    [[create temp function end_date_str(format string) as (]],
    "\tformat_date(format, end_date())",
    [[);]],
  }),
})

ls.add_snippets("python", {
  s("docstring", t{
    [[#standardSQL]],
    string.format(
      "create temp function start_date() as (date '%s');",
      F.today('%Y-%m-%d')
    ),
    [[create temp function start_date_str(format string) as (]],
    "\tformat_date(format, start_date())",
    [[);]],
    string.format(
      "create temp function end_date() as (date '%s');",
      F.today('%Y-%m-%d')
    ),
    [[create temp function end_date_str(format string) as (]],
    "\tformat_date(format, end_date())",
    [[);]],
  }),
})

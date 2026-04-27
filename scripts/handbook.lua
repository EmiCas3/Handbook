-- handbook.lua: cache-safe version (namespaced, no collisions)

local code_index = 0

-- sanitize file path into safe prefix
local function sanitize_path(path)
  local s = path:gsub("[/\\%.%-]", "_")
  return s
end

-- safely get current file name
local current_file =
  (PANDOC_STATE and PANDOC_STATE.input_files and PANDOC_STATE.input_files[1])
  or "unknown"

local prefix = sanitize_path(current_file)

-- ensure cache directory exists
local function ensure_dir(dir)
  os.execute("mkdir -p " .. dir)
end

-- CODE BLOCKS → external cached files
function CodeBlock(el)
  code_index = code_index + 1

  local dir = "_pandoc_cache"
  ensure_dir(dir)

  local fname = string.format(
    "%s/%s_code_%04d.verbatim",
    dir,
    prefix,
    code_index
  )

  local f = io.open(fname, "w")
  if f then
    f:write(el.text)
    f:close()
  end

  return pandoc.RawBlock("latex", "\\codeInput{" .. fname .. "}")
end

-- INLINE CODE → LaTeX safe inline macro
function Code(el)
  local t = el.text

  t = t:gsub("\\", "\\textbackslash{}")
  t = t:gsub("{",  "\\{")
  t = t:gsub("}",  "\\}")
  t = t:gsub("#",  "\\#")
  t = t:gsub("%$", "\\$")
  t = t:gsub("%%", "\\%%")
  t = t:gsub("&",  "\\&")
  t = t:gsub("_",  "\\_")
  t = t:gsub("%^", "\\^{}")
  t = t:gsub("~",  "\\textasciitilde{}")
  t = t:gsub("<",  "\\textless{}")
  t = t:gsub(">",  "\\textgreater{}")

  return pandoc.RawInline("latex", "\\codeinline{" .. t .. "}")
end

-- HEADERS → LaTeX sections
function Header(el)
  local text = pandoc.utils.stringify(el)
  local cmd

  if     el.level == 1 then cmd = "\\section{"
  elseif el.level == 2 then cmd = "\\subsection{"
  elseif el.level == 3 then cmd = "\\subsubsection{"
  elseif el.level == 4 then cmd = "\\paragraph{"
  else                      cmd = "\\textbf{"
  end

  return pandoc.RawBlock("latex", cmd .. text .. "}")
end

-- SPECIAL MATH HANDLING FIX
function Math(el)
  if el.text == "\\clearpage" then
    return pandoc.RawInline("latex", "\\clearpage")
  end
end
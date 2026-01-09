-- final-formatted-bib.lua
function Pandoc(doc)
    local refs = doc.meta.references
    if not refs then return end
    
    local lines = {}
    
    -- CONFIGURATION: Surnames to bold
    local bold_surnames = {
        ["Wilby"] = true,
        ["Wyld"] = true
    }

    local function clean_str(s)
        if s == nil then return "" end
        local str = pandoc.utils.stringify(s)
        return str:gsub('"', '\\"')
    end

    local ignore_keys = { 
        abstract = true, 
        ["container-title"] = true, 
        ["publisher-place"] = true 
    }

    for _, ref in ipairs(refs) do
        table.insert(lines, "- ")
        
        -- Map journal
        if ref['container-title'] and not ref.journal then
            ref.journal = ref['container-title']
        end

        -- Determine the URL for the title link
        local target_url = ref.url and clean_str(ref.url) or nil

        for key, val in pairs(ref) do
            if not ignore_keys[key] then
                if key == "title" then
                    local title_text = clean_str(val)
                    if target_url then
                        -- Format as HTML link with target="_blank"
                        table.insert(lines, "  title: \"<a href='" .. target_url .. "' target='_blank'>" .. title_text .. "</a>\"")
                    else
                        table.insert(lines, "  title: \"" .. title_text .. "\"")
                    end
                elseif key == "author" then
                    table.insert(lines, "  author:")
                    for _, auth in ipairs(val) do
                        local given = auth.given and (clean_str(auth.given) .. " ") or ""
                        local family = auth.family and clean_str(auth.family) or ""
                        local full = (given .. family):gsub("^%s*(.-)%s*$", "%1")
                        
                        if auth.family and bold_surnames[clean_str(auth.family)] then
                            full = "**" .. full .. "**"
                        end
                        table.insert(lines, "    - \"" .. full .. "\"")
                    end
                elseif key == "issued" and type(val) == "table" and val['date-parts'] then
                    local dp = val['date-parts'][1]
                    local ds = tostring(dp[1])
                    if dp[2] then ds = ds .. "-" .. string.format("%02d", dp[2]) end
                    table.insert(lines, "  issued: \"" .. ds .. "\"")
                else
                    table.insert(lines, "  " .. key .. ": \"" .. clean_str(val) .. "\"")
                end
            end
        end
    end

    print(table.concat(lines, "\n"))
    os.exit()
end
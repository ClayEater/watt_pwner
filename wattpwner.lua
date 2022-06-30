--[[
    watt_pwner: a wattpad multitool by oj simpson and an anonymous collaborator
    version 0.3 beta
]]
print("\27[38;5;255m")
-- Requires
local json = require("json")
local http = require("coro-http")
-- Constants
local Version = "0.3-beta"
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
    local home_url = "https://www.wattpad.com/v5/home"
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
    local data = json.decode(response.Body)
    for i,v in pairs(data.sections) do
        if v.type == "greeting" then
            return v.data.greeting:sub(15,-2)
        end
    end
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



-- Actual code and shit
print("\27[48;5;129mWelcome to watt_pwner version "..Version.."!\nCreated by OJ Simpson and an anonymous collaborator\27[48;5;0m")
print("Please select an option:\n")
print("[1] Account creator")
print("[2] Conversation spammer")
print("[3] Verify tokens")
print("[4] Report bot")
print("[5] Follow bot")
print("[6] Message bot\n")
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
    --local expressvpn_integration = GetInput("AutoVpnSwitch (ExpressVPN + GNU/Linux ONLY!) (y/n)")
    local expressvpn_integration = "n" -- DO NOT ENABLE, HIGHLY BUGGY
    if expressvpn_integration:lower() == "y" then
        print("\27[48;5;1mAutoVpnSwitch is very unstable. It is recommended not to use it.\nAutoVpnSwitch REQUIRES ExpressVPN and GNU/Linux\27[48;5;0m")
    end
    local switchingvpns = false
    for i = 1,msges,1 do
        local s,e = pcall(function()
            wait(delay)
            if expressvpn_integration:lower() == "y" and (i/10 == math.floor(i/10)) then
                print("Auto switching VPNs")
                --coroutine.wrap(function()
                    local switchingvpns = true
                    os.execute("expressvpn disconnect && expressvpn connect")
                    wait(5)
                    switchingvpns = false
                    print("Continuing..")
                --end)()
            end
            if switchingvpns == false then
                local request = {
                    body = readfile("message.txt"),
                    broadcast = false,
                    createDate = nil,
                    from = nil,
                    id = nil,
                    isReply = false,
                    ownername = user,
                    parent_id = nil,
                    parentId = nil
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
                    print("\27[38;5;255m["..i.."] Success!, Token: "..thistoken)
                else
                    print("\27[38;5;1m["..i.."] Error: "..response.Body..", Token: "..thistoken)
                end
            end
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
            print("\27[38;5;120mValid token, Token: "..thistoken)
        else
            print("\27[38;5;1mInvalid token, Token: "..thistoken)
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
            print("\27[38;5;120m["..i.."] Sent Report! Name used: "..id.Name.."\27[38;5;255m")
        else
            print("\27[38;5;1m["..i.."] "..response.Body.."\27[38;5;255m")
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
                print("\27[38;5;120m["..i.."] Followed!, Token: "..v.."\27[38;5;255m")
            else
                print("\27[38;5;1m["..i.."] "..response.Body..", Token: "..v.."\27[38;5;255m")
            end
        else
            print("\27[38;5;1m["..i.."] Invalid Token, Token: "..v.."\27[38;5;255m")
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
    local user = GetInput("User to spam")
    local msg = GetInput("Message to spam")
    local amount_msgs = tonumber(GetInput("Number of messages"))
    for i = 1,amount_msgs do
        local thistoken = token[math.random(1,#token)]
        if is_valid_token(thistoken) then
            local thisuser = get_user_from_token(thistoken)
            local response = http_request(
                {
                    Url = "https://www.wattpad.com/api/v3/users/"..thisuser.."/inbox/"..user, 
                    Method = "POST",
                    Headers = {
                        {"content-type","application/x-www-form-urlencoded; charset=UTF-8"},
                        {"Cookie","wp_id=22700821-b1ca-4df7-b2ef-48a7ed608faf; fs__exp=4; lang=1; locale=en_US; ff=1; dpr=1; tz=-1; te_session_id=1652040028384; _ga_FNDTZ0MZDQ=GS1.1.1652119923.5.1.1652119960.0; _ga=GA1.1.40407520.1652040029; signupFrom=user_profile; OptanonConsent=isIABGlobal=false&datestamp=Mon+May+09+2022+19%3A12%3A39+GMT%2B0100+(British+Summer+Time)&version=6.10.0&hosts=&consentId=8d8b4b14-e875-4d96-a70a-0ae697964260&interactionCount=1&landingPath=NotLandingPage&groups=C0001%3A1%2CC0002%3A1%2CC0004%3A1%2CC0003%3A1%2CSTACK…_t0eY1P9_7__-0zjhfdt-8N3f_X_L8X42M7vF36pq4KuR4Eu3LBIQdlHOHcTUmw6okVrzPsbk2cr7NKJ7PEmnMbO2dYGH9_n93TuZKY7_____7z_v-v_v____f_7-3f3__5_3---_e_V_99zbn9_____9nP___9v-_9________4IsgEmGpeQBdiWODJtGkUKIEYVhIdQKACigGFoisIHVwU7K4CfUELABAKgIwIgQYgowYBAAIBAEhEQEgB4IBEARAIAAQAKgEIACNgEFgBYGAQACgGhYgRQBCBIQZEBEcpgQESJRQT2ViCUHexphCHWWAFAo_oqEBEoAQLAyEhYOY4AkBLhZIFmKF8gBGCAAA.f_gAD_gAAAAA; nextUrl=%2Fhome; isStaff=1; hc=1; token="..thistoken}
                    },
                    Body = "sender="..thisuser.."&recipient="..user.."&body="..msg
                }
            )
            if response.result.code == 200 then
                print("\27[38;5;120m["..i.."] Sent message!, Token: "..thistoken.."\27[38;5;255m")
            else
                print("\27[38;5;1m["..i.."] "..response.Body..", Token: "..thistoken.."\27[38;5;255m")
            end
        end
    end
end
print("\27[38;5;255m")
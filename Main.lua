local ADDON_NAME = ...;
local Whotxt = ""
local Who = {}
local WhoNo = 1
local Queries = 0
local WhoTime = time()
if UnitFactionGroup("player") == "Alliance" then
	Who = {
-------------------联盟查询关键词-------------------
--格式参考："地名","职业","种族","等级下限-等级上限"
	{"玛拉顿","法师","人类","60-60"},
	{"玛拉顿","法师","侏儒","60-60"},
	{"祖尔法拉克","法师","人类","60-60"},
	{"祖尔法拉克","法师","侏儒","60-60"},
	{"奥达曼","法师","人类","60-60"},
	{"奥达曼","法师","侏儒","60-60"},
	{"阿塔哈卡神庙","法师","人类","60-60"},
	{"阿塔哈卡神庙","法师","侏儒","60-60"},
	{"黑石塔","法师","人类","60-60"},
	{"黑石塔","法师","侏儒","60-60"},
	{"斯坦索姆","法师","人类","60-60"},
	{"斯坦索姆","法师","侏儒","60-60"},
	{"提瑞斯法林地","","","1-20"},
	{"凄凉之地","","","1-20"},
	{"厄运之槌","","","1-20"},
	{"东瘟疫之地","","","1-20"},
	{"黑石山","","","1-20"},
	{"荆棘谷","","","1-20"},
	{"冬泉谷","","","1-20"},
	{"塔纳利斯","","","1-20"},
	{"希利苏斯","","","1-20"},
	{"暴风城","战士","","1-1"},
	{"暴风城","圣骑士","","1-1"},
	{"暴风城","猎人","","1-1"},
	{"暴风城","潜行者","","1-1"},
	{"暴风城","德鲁伊","","1-1"},
	{"暴风城","法师","","1-1"},
	{"暴风城","术士","","1-1"},
	{"暴风城","牧师","","1-1"},
	{"铁炉堡","战士","","1-1"},
	{"铁炉堡","圣骑士","","1-1"},
	{"铁炉堡","猎人","","1-1"},
	{"铁炉堡","潜行者","","1-1"},
	{"铁炉堡","德鲁伊","","1-1"},
	{"铁炉堡","法师","","1-1"},
	{"铁炉堡","术士","","1-1"},
	{"铁炉堡","牧师","","1-1"},

}
elseif UnitFactionGroup("player") == "Horde" then
	Who = {
-------------------部落查询关键词-------------------
--格式参考："地名","职业","种族","等级下限-等级上限"
	{"玛拉顿","法师","亡灵","60-60"},
	{"玛拉顿","法师","巨魔","60-60"},
	{"祖尔法拉克","法师","亡灵","60-60"},
	{"祖尔法拉克","法师","巨魔","60-60"},
	{"奥达曼","法师","亡灵","60-60"},
	{"奥达曼","法师","巨魔","60-60"},
	{"阿塔哈卡神庙","法师","亡灵","60-60"},
	{"阿塔哈卡神庙","法师","巨魔","60-60"},
	{"黑石塔","法师","亡灵","60-60"},
	{"黑石塔","法师","巨魔","60-60"},
	{"斯坦索姆","法师","亡灵","60-60"},
	{"斯坦索姆","法师","巨魔","60-60"},
	{"凄凉之地","","","1-20"},
	{"厄运之槌","","","1-20"},
	{"东瘟疫之地","","","1-20"},
	{"黑石山","","","1-20"},
	{"荆棘谷","","","1-20"},
	{"冬泉谷","","","1-20"},
	{"塔纳利斯","","","1-20"},
	{"希利苏斯","","","1-20"},
	{"荒芜之地","","","1-20"},
	{"悲伤沼泽","","","1-20"},
	{"奥格瑞玛","战士","","1-1"},
	{"奥格瑞玛","萨满祭司","","1-1"},
	{"奥格瑞玛","猎人","","1-1"},
	{"奥格瑞玛","潜行者","","1-1"},
	{"奥格瑞玛","德鲁伊","","1-1"},
	{"奥格瑞玛","法师","","1-1"},
	{"奥格瑞玛","术士","","1-1"},
	{"奥格瑞玛","牧师","","1-1"},

}
end
--------------------------------------------------------

CopyWhoListMixin = {};

function CopyWhoListMixin:OnLoad()
    self:RegisterEvent("ADDON_LOADED");
end

function CopyWhoListMixin:OnEvent(event, ...)
    if (event == "ADDON_LOADED") then
        if (ADDON_NAME == ...) then
            self:OnAddOnLoaded();
        end
    elseif (event == "WHO_LIST_UPDATE") then
        self:OnWhoListUpdate();
    elseif (event == "MAIL_SHOW") then
        self:OnMailShow();
    elseif (event == "MAIL_CLOSED") then
        self:OnMailClosed();
    end
end

function CopyWhoListMixin:OnAddOnLoaded(...)
    self:UnregisterEvent("ADDON_LOADED");
    self:RegisterEvent("WHO_LIST_UPDATE");
    self:RegisterEvent("MAIL_SHOW");

    local btn = CreateFrame("Button", "WhoFrameCopyButton", WhoFrame, "UIPanelButtonTemplate");
    btn:SetFrameStrata("HIGH");
    btn:SetSize(100, 26);
    btn:SetText("Copy List");
    btn:SetPoint("CENTER", 110, 172);
    btn:SetScript("OnClick", self.OnCopyListClick)
    self:OnWhoListUpdate();
    btn:Show();

    local btnBattle = CreateFrame("Button", "BattlegroundFrameCopyButton", WorldStateScoreFrame, "UIPanelButtonTemplate");
    btnBattle:SetFrameStrata("HIGH");
    btnBattle:SetSize(100, 22);
    btnBattle:SetText("Copy Names");
    btnBattle:SetPoint("CENTER", "WorldStateScoreFrameCloseButton", "LEFT", -46, 1);
    btnBattle:SetScript("OnClick", self.OnCopyBattleNamesClick)
    btnBattle:Show();
end

function CopyWhoListMixin:OnWhoListUpdate(...)
    --local num = C_FriendList.GetNumWhoResults();
   local num = 1
    WhoFrameCopyButton:SetEnabled(num and num > 0);
end

function CopyWhoListMixin:OnCopyListClick(...)
	--如果当前关键词不存在，则停止查询
	if (Who[WhoNo] == nil) then
		CopyWhoListMixin:CopyWhoFrameShow(Whotxt);
		print("所有预设关键词已查询完毕，请按CTRL+C复制查询结果")
		return ;
	end

	--获取查询结果
	local num = C_FriendList.GetNumWhoResults()
	--如果查询结果为0，则重新查询
	if (num == nil or num <= 0) then
		--关键词查询8次无结果则跳过
		if Queries >= 8 then
			WhoNo = WhoNo + 1
			Queries = 0
		end
		--每次查询间隔1秒
		if (WhoTime <= time() - 1) then
			C_FriendList.SendWho('z-"'..Who[WhoNo][1]..'" '..'c-"'..Who[WhoNo][2]..'" '..'r-"'..Who[WhoNo][3]..'" '..Who[WhoNo][4])
			Queries = Queries + 1
			WhoTime = time()
			print("查询关键词"..WhoNo.."："..Who[WhoNo][1].." "..Who[WhoNo][2].." "..Who[WhoNo][3].." "..Who[WhoNo][4].."，次数："..Queries..(Queries >= 8 and "（查询8次无结果则跳过）"or""))
		end
	else
		--查询结果有延迟，判断查询结果是否符合关键词，如果符合则获取名单写入编辑框，并切换下一个关键词，如果不符合则重新查询
		local info = C_FriendList.GetWhoInfo(1)
		if (Who[WhoNo][1] == "" or info.area == Who[WhoNo][1]) and (Who[WhoNo][2] == "" or info.classStr == Who[WhoNo][2]) and (Who[WhoNo][3] == "" or info.raceStr == Who[WhoNo][3]) and (Who[WhoNo][4] == "" or (info.level >= tonumber(string.sub(Who[WhoNo][4],1,string.find(Who[WhoNo][4],"-")-1)) and info.level <= tonumber(string.sub(Who[WhoNo][4],string.find(Who[WhoNo][4],"-")+1,-1)))) then
			local txt = "";
			local realm = GetRealmName();
			local playerName = GetUnitName("player");
			for i = 1, num do
				info = C_FriendList.GetWhoInfo(i);
				if (info.fullName ~= playerName) then
					txt = txt .. info.fullName .. "/" .. realm .. (i < num and "\n" or "");
				end
			end
			Whotxt = Whotxt .. txt .. "\n\n"
			WhoNo = WhoNo + 1
			Queries = 0
			CopyWhoListMixin:CopyWhoFrameShow(Whotxt);
			print("查询成功：获取名单到编辑框")
		else
			--关键词查询8次无结果则跳过
			if Queries >= 8 then
				WhoNo = WhoNo + 1
				Queries = 0
			end
			--每次查询间隔1秒
			if (WhoTime <= time() - 1) then
				C_FriendList.SendWho('z-"'..Who[WhoNo][1]..'" '..'c-"'..Who[WhoNo][2]..'" '..'r-"'..Who[WhoNo][3]..'" '..Who[WhoNo][4])
				Queries = Queries + 1
				WhoTime = time()
				print("查询关键词"..WhoNo.."："..Who[WhoNo][1].." "..Who[WhoNo][2].." "..Who[WhoNo][3].." "..Who[WhoNo][4].."，次数："..Queries..(Queries >= 8 and "（查询8次无结果则跳过）"or""))
			end
		end
	end
end

function CopyWhoListMixin:OnCopyBattleNamesClick(...)
    local num = GetNumBattlefieldScores();
    if (num == nil or num <= 0) then
        return ;
    end

    local fullName, name, server;
    local txt = "";
    local realm = GetRealmName();
    local playerName = UnitName("player");

    for i = 1, num do
        fullName = GetBattlefieldScore(i);
        if (fullName ~= playerName) then
            name, server = strsplit("-", fullName);
            txt = txt .. name .. "/" .. (server == nil and realm or server) .. (i < num and "\n" or "");
        end
    end

    CopyWhoListMixin:CopyWhoFrameShow(txt);
end

function CopyWhoListMixin:CopyWhoFrameShow(text)
    if not CopyWhoFrame then
        local frame = CreateFrame("Frame", "CopyWhoFrame", UIParent, "UIPanelDialogTemplate");
        frame:SetFrameStrata("HIGH");
        frame:SetPoint("CENTER");
        frame:SetSize(500, 400);

        frame.Title:SetText("CopyWhoList - By NeoPeng");

        -- Resizable
        frame:SetResizable(true);
        frame:SetMinResize(350, 200);

        -- Movable
        frame:SetMovable(true);
        frame:SetClampedToScreen(true);
        frame:SetScript("OnMouseDown", function()
            frame:StartMoving();
        end);
        frame:SetScript("OnMouseUp", function()
            frame:StopMovingOrSizing();
        end);

        -- ScrollFrame
        local scroll = CreateFrame("ScrollFrame", "CopyWhoFrameScrollFrame", CopyWhoFrame, "UIPanelScrollFrameTemplate");
        scroll:SetPoint("LEFT", 14, 0);
        scroll:SetPoint("RIGHT", -32, 0);
        scroll:SetPoint("TOP", 0, -32);
        scroll:SetPoint("BOTTOM", 0, 14);

        -- EditBox
        local editbox = CreateFrame("EditBox", "CopyWhoFrameEditBox", CopyWhoFrameScrollFrame);
        editbox:SetSize(scroll:GetSize());
        editbox:SetMultiLine(true);
        editbox:SetFontObject("FriendsFont_Small");
        editbox:SetScript("OnEscapePressed", function()
            frame:Hide();
        end);
        scroll:SetScrollChild(editbox);

        local resizer = CreateFrame("Button", "CopyWhoFrameResizeButton", CopyWhoFrame);
        resizer:SetPoint("BOTTOMRIGHT", -5, 8);
        resizer:SetSize(12, 12);

        resizer:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up");
        resizer:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight");
        resizer:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down");

        resizer:SetScript("OnMouseDown", function()
            frame:StartSizing("BOTTOMRIGHT");
        end);
        resizer:SetScript("OnMouseUp", function()
            frame:StopMovingOrSizing();
        end);
    end

    if text then
        CopyWhoFrameEditBox:SetText(text);
        CopyWhoFrameEditBox:HighlightText();
        CopyWhoFrameEditBox:SetFocus();

        PlaySound(SOUNDKIT.GS_TITLE_OPTION_OK);
        CopyWhoFrame:Show();
    end
end

function CopyWhoListMixin:OnMailShow()
    self:UnregisterEvent("MAIL_SHOW");
    self:RegisterEvent("MAIL_CLOSED");

    SetCVar("blockTrades", 1);
    print("|cffff0000CopyWhoList blocked your trades!|r");
end

function CopyWhoListMixin:OnMailClosed()
    self:UnregisterEvent("MAIL_CLOSED");
    self:RegisterEvent("MAIL_SHOW");

    SetCVar("blockTrades", 0);
    print("|cff00ff00CopyWhoList unlocked your trades!|r");
end

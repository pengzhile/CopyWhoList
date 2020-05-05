local ADDON_NAME = ...;

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
    local num = C_FriendList.GetNumWhoResults();

    WhoFrameCopyButton:SetEnabled(num and num > 0);
end

function CopyWhoListMixin:OnCopyListClick(...)
    local num = C_FriendList.GetNumWhoResults();
    if (num == nil or num <= 0) then
        return ;
    end

    local info;
    local txt = "";
    local realm = GetRealmName();
    local playerName = GetUnitName("player");

    for i = 1, num do
        info = C_FriendList.GetWhoInfo(i);
        if (info.fullName ~= playerName) then
            txt = txt .. info.fullName .. "/" .. realm .. (i < num and "\n" or "");
        end
    end

    CopyWhoListMixin:CopyWhoFrameShow(txt);
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
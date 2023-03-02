page 50318 "Get Token"
{
    ApplicationArea = All;
    Caption = 'Get Token';
    UsageCategory = Administration;
    Editable = true;

    layout
    {
        area(Content)
        {
            group(Setup)
            {
                Caption = 'Setup';

                field(ClientId; ClientId)
                {
                    ApplicationArea = All;
                    Caption = 'Application (client) ID';
                }
                field(ClientSecret; ClientSecret)
                {
                    ApplicationArea = All;
                    Caption = 'Client secret';
                    ExtendedDatatype = Masked;
                }
                field(RedirectURL; RedirectURL)
                {
                    ApplicationArea = All;
                    Caption = 'Redirect URI';
                    ToolTip = 'When not Redirect Url is specified, the default Redirect Url is used instead.';
                }
                field(AuthorityURL; MicrosoftOAuth2Url)
                {
                    ApplicationArea = All;
                    Caption = 'Authorization Endpoint';
                }
                field(TenantId; AadTenantId)
                {
                    ApplicationArea = All;
                    Caption = 'Directory (tenant) ID';
                    trigger OnValidate()
                    begin
                        OAuthAdminConsentUrl := ReplaceCommonTenant(OAuthAdminConsentUrl);
                        MicrosoftOAuth2Url := ReplaceCommonTenant(MicrosoftOAuth2Url);
                    end;
                }
                field(UserEmail; UserEmail)
                {
                    ApplicationArea = All;
                    Caption = 'User Email';
                }
            }
            group("Authentication")
            {
                Caption = 'Authentication';
                field(GrantType; GrantType)
                {
                    ApplicationArea = All;
                    Caption = 'Grant Type';
                    OptionCaption = 'Client Credentials(v1.0),Authorization Code(v1.0),On-Behalf-Of(v1.0),Authorization Code From Cache(v1.0),On-Behalf-Of Token and Token Cache(v1.0),On-Behalf-Of New Token and Token Cache(v1.0),Client Credentials(v2.0),Authorization Code(v2.0),On-Behalf-Of(v2.0),Authorization Code From Cache(v2.0),On-Behalf-Of Token and Token Cache(v2.0),On-Behalf-Of New Token and Token Cache(v2.0)';

                    trigger OnValidate()
                    begin
                        AuthError := '';
                        AccessToken := '';
                        APICallResponse := '';
                        Result := 'Success';
                        ErrorMessage := '';
                    end;
                }
            }
            group(Results)
            {
                Caption = 'Results';
                Editable = false;
                field(Status; Result)
                {
                    ApplicationArea = All;
                    Caption = 'Result';
                    StyleExpr = ResultStyleExpr;
                }

                field(AccessToken; AccessToken)
                {
                    ApplicationArea = All;
                    Caption = 'Access Token';
                }
                field(TokenCache; TokenCache)
                {
                    ApplicationArea = All;
                    Caption = 'Token Cache';
                }
                field(ErrorMessage; ErrorMessage)
                {
                    ApplicationArea = All;
                    Caption = 'Error Message';
                }
            }
            group(APICall)
            {
                Caption = 'Graph API';
                field(APICallResponse; APICallResponse)
                {
                    ApplicationArea = All;
                    Caption = 'API Call Response';
                    trigger OnAssistEdit()
                    begin
                        if APICallResponse = '' then
                            exit;
                        Message(APICallResponse);
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GetToken)
            {
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;
                Caption = 'Get Token';
                Image = ServiceSetup;

                trigger OnAction()
                begin
                    case GrantType of
                        GrantType::ClientCredsV1:
                            ClientCredentialsV1();
                        GrantType::AuthCodeV1:
                            AuthorizationCodeV1();
                        GrantType::AuthCodeCacheV1:
                            AcquireAuthCodeTokenFromCacheV1();
                        GrantType::ClientCredsV2:
                            ClientCredentialsV2();
                        GrantType::AuthCodeV2:
                            AuthorizationCodeV2();
                        GrantType::AuthCodeCacheV2:
                            AcquireAuthCodeTokenFromCacheV2();


                    end;
                end;
            }
            action(CallApi)
            {
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;
                Caption = 'Call API';
                Image = ChangeStatus;
                // trigger OnAction()
                // begin
                //     if AccessToken = '' then
                //         Error('No Access Token has been acquired');
                //     if GrantType in [GrantType::ClientCredsV1, GrantType::ClientCredsV2] then
                //         APICallResponse := APICalls.CreateRequest('https://api.businesscentral.dynamics.com/v2.0/abc87ed0-4014-486f-afd8-1577c92442a6/KohinoorSandbox/WS/CRONUS%20IN/Codeunit/POSEventandSubscriber', AccessToken)
                //     // https://graph.microsoft.com/v1.0/users
                //     //https://api.businesscentral.dynamics.com/v2.0/abc87ed0-4014-486f-afd8-1577c92442a6/KohinoorSandbox/WS/CRONUS%20IN/Codeunit/POSEventandSubscriber
                //     else
                //         APICallResponse := APICalls.CreateRequest('https://graph.microsoft.com/v1.0/me', AccessToken);
                // end;
            }
            action(AdminPermissions)
            {
                ApplicationArea = All;
                Caption = 'Admin Consent';
                Image = Administration;

                trigger OnAction()
                var
                    HasGrantCOnsentFlowSucceeded: Boolean;
                begin
                    OAuth2.RequestClientCredentialsAdminPermissions(ClientId, OAuthAdminConsentUrl, RedirectURL, HasGrantCOnsentFlowSucceeded, AccessToken);

                    if HasGrantCOnsentFlowSucceeded then
                        Message('Admin grant consent has succeeded.')
                    else begin
                        Message('Admin grant consent has failed with the error: ' + AuthError);
                        Result := 'Error';
                    end;
                end;
            }
            action("Token")
            {
                ApplicationArea = all;
                trigger OnAction()
                var
                    Rediract: Text;
                    ResoURL: Text;
                    Client: HttpClient;
                    JsonTokenResult: Text;
                    Response: HttpResponseMessage;
                    content: HttpContent;
                    ResponseTxt: Text;
                    J: JsonObject;
                    AccessTokenNew: Text;
                begin

                    OAuth2.AcquireTokenWithClientCredentials(ClientId, ClientSecret, MicrosoftOAuth2Url, Rediract, 'https://api.businesscentral.dynamics.com', AccessToken);
                    //OAuth2.AcquireTokenWithClientCredentials(ClientId, ClientSecret, MicrosoftOAuth2Url, RedirectURL, ResourceURL, AccessToken);
                    //Message('Access %1', AccessToken);

                    AccessTokenNew := GetTokenFun('https://api.businesscentral.dynamics.com', ClientId, ClientSecret);
                    Message('Access %1', AccessTokenNew);

                end;
            }
        }
    }


    var
        OAuth2: Codeunit Oauth2;
        APICalls: Codeunit APICalls;
        GrantType: Option ClientCredsV1,AuthCodeV1,AuthCodeCacheV1,ClientCredsV2,AuthCodeV2,AuthCodeCacheV2;
        ClientId: Text;
        ClientSecret: Text;
        MicrosoftOAuth2Url: Text;
        OAuthAdminConsentUrl: Text;
        ResourceURL: Label 'https://graph.microsoft.com/';
        //ResourceURL: Label 'https://api.businesscentral.dynamics.com/v2.0/abc87ed0-4014-486f-afd8-1577c92442a6/KohinoorSandbox/WS/CRONUS%20IN/Codeunit/POSEventandSubscriber/';
        AadTenantId: Text;
        Result: Text;
        ResultStyleExpr: Text;
        APICallResponse: Text;
        ErrorMessage: Text;
        UserEmail: Text;
        RedirectURL: Text;
        AccessToken: Text;
        TokenCache: Text;
        NewTokenCache: Text;
        AuthError: Text;

    local procedure ClientCredentialsV1()
    begin
        OAuth2.AcquireTokenWithClientCredentials(ClientId, ClientSecret, MicrosoftOAuth2Url, RedirectURL, ResourceURL, AccessToken);

        if AccessToken = '' then
            DisplayErrorMessage('')
        else
            Result := 'Success';
        SetResultStyle();

        Message(AccessToken);
    end;

    local procedure AuthorizationCodeV1()
    var
        PromptInteraction: Enum "Prompt Interaction";
    begin
        OAuth2.AcquireTokenByAuthorizationCode(ClientId, ClientSecret, MicrosoftOAuth2Url, RedirectURL, ResourceURL, PromptInteraction::"Admin Consent", AccessToken, AuthError);

        if AccessToken = '' then
            DisplayErrorMessage(AuthError)
        else
            Result := 'Success';
        SetResultStyle();
    end;

    local procedure AcquireAuthCodeTokenFromCacheV1()
    begin
        OAuth2.AcquireAuthorizationCodeTokenFromCache(ClientId, ClientSecret, RedirectURL, MicrosoftOAuth2Url, ResourceURL, AccessToken);

        if AccessToken = '' then
            DisplayErrorMessage('')
        else
            Result := 'Success';
        SetResultStyle();
    end;

    local procedure ClientCredentialsV2()
    var
        Scopes: List of [Text];
    begin
        Scopes.Add(ResourceURL + '.default');

        OAuth2.AcquireTokenWithClientCredentials(ClientId, ClientSecret, MicrosoftOAuth2Url, RedirectURL, Scopes, AccessToken);

        if AccessToken = '' then
            DisplayErrorMessage('')
        else
            Result := 'Success';
        SetResultStyle();
    end;

    local procedure AuthorizationCodeV2()
    var
        PromptInteraction: Enum "Prompt Interaction";
        Scopes: List of [Text];
        Scope: Text;
    begin
        Scopes.Add(ResourceURL + 'user.read');
        OAuth2.AcquireTokenByAuthorizationCode(ClientId, ClientSecret, MicrosoftOAuth2Url, RedirectURL, Scopes, PromptInteraction::Consent, AccessToken, AuthError);

        if AccessToken = '' then
            DisplayErrorMessage(AuthError)
        else
            Result := 'Success';
        SetResultStyle();
    end;

    local procedure AcquireAuthCodeTokenFromCacheV2()
    var
        Scopes: List of [Text];
    begin
        Scopes.Add(ResourceURL + 'user.read');
        OAuth2.AcquireAuthorizationCodeTokenFromCache(ClientId, ClientSecret, RedirectURL, MicrosoftOAuth2Url, Scopes, AccessToken);

        if AccessToken = '' then
            DisplayErrorMessage('')
        else
            Result := 'Success';
        SetResultStyle();
        //Message(AccessToken);
    end;

    local procedure ClientCredentialsAdminPermissions()
    var
        HasGrantCOnsentFlowSucceeded: Boolean;
    begin
        OAuth2.RequestClientCredentialsAdminPermissions(ClientId, OAuthAdminConsentUrl, RedirectURL, HasGrantCOnsentFlowSucceeded, AccessToken);

        if HasGrantCOnsentFlowSucceeded then
            Result := 'Success'
        else begin
            ErrorMessage := 'Admin grant consent has failed with the error: ' + AuthError;
            Result := 'Error';
        end;
        SetResultStyle();
    end;

    trigger OnOpenPage()
    var
    begin
        // This function is coming up with 17.1
        // OAuth2.GetDefaultRedirectURL(RedirectURL);
        MicrosoftOAuth2Url := 'https://login.microsoftonline.com/common/oauth2/';
        OAuthAdminConsentUrl := 'https://login.microsoftonline.com/common/adminconsent'
    end;

    local procedure SetResultStyle()
    begin
        if Result = 'Success' then
            ResultStyleExpr := 'Favorable';

        if Result = 'Error' then
            ResultStyleExpr := 'Unfavorable';
    end;

    local procedure DisplayErrorMessage(AuthError: Text)
    begin
        Result := 'Error';
        if AuthError = '' then
            ErrorMessage := 'Authorization has failed.'
        else
            ErrorMessage := StrSubstNo('Authorization has failed with the error: %1.', AuthError);
    end;

    local procedure ReplaceCommonTenant(Authority: Text): Text;
    var
        TenantStartPos: Integer;
        TenantEndPos: Integer;
        AuthorityAfterTenant: Text;
    begin
        TenantStartPos := StrPos(Authority, '.com/') + 5;
        TenantEndPos := TenantStartPos + StrPos(CopyStr(Authority, TenantStartPos), '/') - 1;
        AuthorityAfterTenant := CopyStr(Authority, TenantEndPos);
        if (TenantStartPos > 0) and (TenantEndPos > 0) then
            exit(CopyStr(Authority, 1, TenantStartPos - 1) + AadTenantId + AuthorityAfterTenant)
    end;

    local procedure GetTokenFun(Url: Text; client_id: Text; client_secret: Text) myToken: Text
    var
        MyHttpResponseMessage: HttpResponseMessage;
        MyHttpClient: HttpClient;
        myHttpHeaders: HttpHeaders;
        myContent: Text;
        myResponse: Text;
        MyhttpContent: HttpContent;
    begin
        Url += strsubstno('?client_id=%1&client_secret=%2&response_type=code&state=%3', client_id, client_secret, CreateGuid());

        myHttpHeaders := MyHttpClient.DefaultRequestHeaders();
        myHttpHeaders.Add('accept', 'application/json');
        myHttpHeaders.Add('charset', 'UTF-8');
        MyhttpContent.WriteFrom(myContent);
        MyhttpContent.GetHeaders(myHttpHeaders);
        if myHttpHeaders.Contains('Content-Type') then
            myHttpHeaders.Remove('Content-Type');
        myHttpHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');

        MyHttpClient.Get(Url, MyHttpResponseMessage);
        myHttpResponseMessage.Content().ReadAs(myResponse);
        // you have to read myResponse as Json and obtain de token from it and save to myToken
    end;
}
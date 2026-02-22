class SaxoUserAccessRights {
  final String userId;
  final String clientId;
  final List<String> roles;
  final bool canManageCashTransfers;
  final bool canTakePriceSession;
  final bool canTakeTradeSession;
  final bool canTrade;
  final bool canViewAnyClient;
  final String accountAccessMode;

  final List<String> elevatedAuthenticationOperations;
  final List<String> operations;

  SaxoUserAccessRights({
    required this.userId,
    required this.clientId,
    required this.roles,
    required this.canManageCashTransfers,
    required this.canTakePriceSession,
    required this.canTakeTradeSession,
    required this.canTrade,
    required this.canViewAnyClient,
    required this.accountAccessMode,
    required this.elevatedAuthenticationOperations,
    required this.operations,
  });

  factory SaxoUserAccessRights.fromJson(Map<String, dynamic> json) {
    return SaxoUserAccessRights(
      userId: (json['UserId'] as int).toString(),
      clientId: (json['ClientId'] as int).toString(),
      roles: List<String>.from(json['Roles']),
      canManageCashTransfers: json['AccessRights']['CanManageCashTransfers'],
      canTakePriceSession: json['AccessRights']['CanTakePriceSession'],
      canTakeTradeSession: json['AccessRights']['CanTakeTradeSession'],
      canTrade: json['AccessRights']['CanTrade'],
      canViewAnyClient: json['AccessRights']['CanViewAnyClient'],
      accountAccessMode: json['AccountAccessMode'],
      elevatedAuthenticationOperations: List<String>.from(
        json['ElevatedAuthenticationOperations'],
      ),
      operations: List<String>.from(json['Operations']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserId': int.tryParse(userId),
      'ClientId': int.parse(clientId),
      'Roles': roles,
      'AccessRights': {
        'CanManageCashTransfers': canManageCashTransfers,
        'CanTakePriceSession': canTakePriceSession,
        'CanTakeTradeSession': canTakeTradeSession,
        'CanTrade': canTrade,
        'CanViewAnyClient': canViewAnyClient
      },
      'AccountAccessMode': accountAccessMode,
      'ElevatedAuthenticationOperations': elevatedAuthenticationOperations,
      'Operations': operations,
    };
  }

  //+

  // Don't be scared by this list. It just contains all possible operations a user can have.
  // The list is long, because whitelabels can use it for their app, asset managers, advisors and thirdparty apps.

  String? getOperationDesc(String key) {
    const Map<String, String> desc = {
      "OAPI.OP.Admin": "Call one of the admin endpoints.",
      "OAPI.OP.ApproveModels": "User can approve the model.",
      "OAPI.OP.AssignAccountsToModels": "User can assign accounts to models.",
      "OAPI.OP.BulkReportsOnOwnedClients":
          "Can generate reports in bulk for for clients in hierarchy.",
      "OAPI.OP.CanAddBookingForExternalInstrument":
          "Can upload a CSV File for bulk booking.",
      "OAPI.OP.CanAdviseOnOrders": "Can advise on orders on your account.",
      "OAPI.OP.CanAdviseOnOrdersOnOwnedClients":
          "Can advise on orders for clients in hierarchy.",
      "OAPI.OP.CanAdviseOnOrdersOnRestrictedClients":
          "Can advise on orders for linked clients.",
      "OAPI.OP.CanApplyServiceFee": "Can apply service fee on your orders.",
      "OAPI.OP.CanApplyServiceFeeOnAnyClient":
          "Can apply service fees on any client.",
      "OAPI.OP.CanApplyServiceFeeOnOwnedClients":
          "Can apply service fees for clients in hierarchy.",
      "OAPI.OP.CanApplyServiceFeeOnRestrictedClients":
          "Can apply service fees for linked clients.",
      "OAPI.OP.CanMaintainAllInstrumentDocuments":
          "Can read/write/update all instrument documents.",
      "OAPI.OP.CanManageFundInducements": "Manage Fund Inducements.",
      "OAPI.OP.CanManageKID":
          "Can Read and Update Key Information Documents (PRIIPS/KIID).",
      "OAPI.OP.CanTradeOnBehalfOfUser": "Can trade on behalf of users.",
      "OAPI.OP.CanUpdatePriceForUnlistedInstrument":
          "User can update prices for unlisted instruments.",
      "OAPI.OP.CanViewAllInstrumentDocuments":
          "User can read all instrument documents.",
      "OAPI.OP.CreateSupportTicket": "User can create a support ticket.",
      "OAPI.OP.DealCapture": "Allow deal capture trades.",
      "OAPI.OP.DeleteAccountsFromModels":
          "User can delete accounts linked to model.",
      "OAPI.OP.DiagnoseStreaming": "Allows diagnosis of streaming connections.",
      "OAPI.OP.EditBenchmarks": "User can edit benchmarks.",
      "OAPI.OP.EditModels": "User can create and edit the model.",
      "OAPI.OP.EditPartnerSettings": "User can edit partner settings data.",
      "OAPI.OP.EmployeeOnlyLogs": "Can view employee only activity logs.",
      "OAPI.OP.EnableModelsToPartners": "Enable saxo models to partners.",
      "OAPI.OP.FeedbackOnboardingOnOwnedClients":
          "Provide onboarding feedback for clients in hierarchy.",
      "OAPI.OP.FeedbackRenewalsOnOwnedClients":
          "Can respond to renewal status for clients in hierarchy.",
      "OAPI.OP.ManageAccountsOnOwnedClients":
          "Create and update accounts of clients in hierarchy.",
      "OAPI.OP.ManageCashOnOwnedClients":
          "Transfer cash of clients in hierarchy.",
      "OAPI.OP.ManageCashTransferViaFundingAccount":
          "Transfer between WLC funding and client account.",
      "OAPI.OP.ManageCashTransferViaFundingAccountForce":
          "Force transfer between WLC fund and client account.",
      "OAPI.OP.ManageCashTransfers":
          "You can transfer cash in and out on your accounts.",
      "OAPI.OP.ManageCertificates":
          "Manage (create and delete) your certificates.",
      "OAPI.OP.ManageCertificatesOnOwnedClients":
          "Manage user certificates for clients in hierarchy.",
      "OAPI.OP.ManageClientOnboarding":
          "Manage client onboarding (create new clients).",
      "OAPI.OP.ManageCorporateActions": "User can manage corporate actions.",
      "OAPI.OP.ManageCorporateActionsOnAnyClient":
          "Can manage corporate actions on any client.",
      "OAPI.OP.ManageCorporateActionsOnOwnedClients":
          "User can manage corporate actions for clients in hierarchy.",
      "OAPI.OP.ManageCorporateActionsOnRestrictedClients":
          "User can elect on behalf of linked clients.",
      "OAPI.OP.ManageDocumentsOnOwnedClients":
          "Create and update documents for clients in hierarchy.",
      "OAPI.OP.ManageInterAccountTransfers":
          "Allows transfers between your accounts.",
      "OAPI.OP.ManageInterAccountTransfersOnOwnedClients":
          "Allows transfers between accounts of the same client, to be performed for clients in hierarchy.",
      "OAPI.OP.ManagePII": "Manage your PII data.",
      "OAPI.OP.ManagePIIOwnedClients": "Manage PII for clients in hierarchy.",
      "OAPI.OP.ManageSecuritiesTransfers":
          "Can request your security transfers.",
      "OAPI.OP.ManageSecuritiesTransfersOnOwnedClients":
          "Can request security transfers for clients in hierarchy.",
      "OAPI.OP.ManageSubAccountSecuritiesTransfers":
          "Manage sub-account security transfers.",
      "OAPI.OP.ManageSuitability": "Manage your asset type suitability.",
      "OAPI.OP.ManageSuitabilityOnOwnedClients":
          "Manage asset type suitability for clients in hierarchy.",
      "OAPI.OP.ManageSuitabilityOnRestrictedClients":
          "Manage asset type suitability for linked clients.",
      "OAPI.OP.ManageSupportCases": "Manage your support cases.",
      "OAPI.OP.ManageSupportCasesOnOwnedClients":
          "Can manage support cases for clients in hierarchy.",
      "OAPI.OP.OrderPhoneApproval": "Can approve your orders by phone.",
      "OAPI.OP.OrderPhoneApprovalOnAnyClient":
          "Can approve orders by phone on any client.",
      "OAPI.OP.OrderPhoneApprovalOnOwnedClients":
          "Can approve orders by phone of clients in hierarchy.",
      "OAPI.OP.OrderPhoneApprovalOnRestrictedClients":
          "Can approve orders by phone of linked clients.",
      "OAPI.OP.PlatformConfiguration":
          "Allow changes to Investor layout for clients.",
      "OAPI.OP.PlatformConfigurationOnAnyClient":
          "Allow changes to Investor layout for IB clients.",
      "OAPI.OP.PlatformExportScreenContent":
          "User can export screen content to file.",
      "OAPI.OP.PrebookFundingFromExternalSource":
          "Partner to pre-book funds on a client account.",
      "OAPI.OP.RebalanceAccount": "User can rebalance the account.",
      "OAPI.OP.RebalanceModel": "User can rebalance the model.",
      "OAPI.OP.SMSG.ClientOnboarding.Reply":
          "Reply to secure messaging thread on onboarding.",
      "OAPI.OP.SMSG.ClientOnboarding.View":
          "View secure messaging thread on onboarding.",
      "OAPI.OP.SMSG.PCM.Reply": "Reply to your messages on cases.",
      "OAPI.OP.SMSG.PCM.ReplyOnOwnedClients":
          "Reply on cases for clients in hierarchy.",
      "OAPI.OP.SMSG.PartnerCaseManagement.Reply":
          "Reply to secure messaging thread on cases.",
      "OAPI.OP.SMSG.PartnerCaseManagement.View":
          "View secure messaging thread on cases.",
      "OAPI.OP.TakePriceSession":
          "You can upgrade the DataLevel of your session to Premium mode.",
      "OAPI.OP.TakeTradeSession":
          "You can upgrade the TradeLevel of your session to FullTradingAndChat mode.",
      "OAPI.OP.TemporaryParkedOrders": "You can park your orders.",
      "OAPI.OP.TemporaryParkedOrdersOnAnyClient": "Park orders of any client.",
      "OAPI.OP.TemporaryParkedOrdersOnOwnedClients":
          "Park orders for clients in hierarchy.",
      "OAPI.OP.TemporaryParkedOrdersOnRestrictedClients":
          "Park orders for linked clients.",
      "OAPI.OP.Trading": "You can trade.",
      "OAPI.OP.TradingOnOwnedClients":
          "Trade on accounts of clients in hierarchy.",
      "OAPI.OP.TradingOnRestrictedClients":
          "Trade on accounts of linked clients.",
      "OAPI.OP.UpdateLimitConfiguration":
          "You can update the limit configuration in liquidity management.",
      "OAPI.OP.UserPreferences": "Can change your user preferences.",
      "OAPI.OP.UserPreferencesForAnyClients":
          "Can change user preferences on any clients.",
      "OAPI.OP.UserPreferencesForOwnedClients":
          "Can change user preferences for clients in hierarchy.",
      "OAPI.OP.View": "You have view-access.",
      "OAPI.OP.ViewAllModelConnections": "You can view all model connections.",
      "OAPI.OP.ViewAnyClient": "See data for any client.",
      "OAPI.OP.ViewAnyInstrument": "See data for any instrument.",
      "OAPI.OP.ViewBenchmarks": "User can view benchmarks.",
      "OAPI.OP.ViewCashTransferViaFundingAccount":
          "View status of transfer between WLC funding and client.",
      "OAPI.OP.ViewModels": "User can view data of models.",
      "OAPI.OP.ViewOnboardingOnOwnedClients":
          "View onboarding status of clients in hierarchy.",
      "OAPI.OP.ViewOwnClientModelConnections":
          "You can view your model connection.",
      "OAPI.OP.ViewOwnClientModels": "You can view accounts linked to model.",
      "OAPI.OP.ViewOwnedClients": "User can view clients in hierarchy.",
      "OAPI.OP.ViewPII": "View your PII data.",
      "OAPI.OP.ViewPIIOnRestrictedClients":
          "Can see PII data of linked clients.",
      "OAPI.OP.ViewPIIOwnedClients": "View PII data for clients in hierarchy.",
      "OAPI.OP.ViewPartnerSettings": "User can view partner settings.",
      "OAPI.OP.ViewRelayoutReport":
          "Can view the historical reports in updated layout.",
      "OAPI.OP.ViewRenewalsOnOwnedClients":
          "User can view renewal status of clients in hierarchy.",
      "OAPI.OP.ViewRestrictedClients": "User can see linked clients.",
      "OAPI.OP.ViewSaxoModels": "User can view Saxo models.",
      "OAPI.OP.ViewSuitability": "View your instrument suitability.",
      "OAPI.OP.ViewSuitabilityOnAnyClient":
          "View asset type suitability for all clients.",
      "OAPI.OP.ViewSuitabilityOnOwnedClients":
          "View asset type suitability for clients in hierarchy.",
      "OAPI.OP.ViewSuitabilityOnRestrictedClients":
          "View asset type suitability of linked clients.",
      "OAPI.OP.ViewSupportCases": "View your support cases.",
      "OAPI.OP.ViewSupportCasesOnOwnedClients":
          "Can view support cases for clients in hierarchy."
    };

    return desc[key];
  }

  String? getRoleDesc(String key) {
    const Map<String, String> desc = {
      "OAPI.Roles.AnonymousSaxoApplication":
          "You are signed in using a Saxobank application.",
      "OAPI.Roles.AnonymousThirdPartyApplication":
          "You are signed in with a thirdparty application.",
      "OAPI.Roles.ApproveModels": "Can approve models created by other users.",
      "OAPI.Roles.CommunityAccessApplication":
          "You are signed in using a community application.",
      "OAPI.Roles.ContentEditor":
          "You can edit the layout and media used in the Saxo Investor Platform.",
      "OAPI.Roles.Default": "Regular customer.",
      "OAPI.Roles.Default.StepUpAuthentication":
          "You are a regular customer, but stepup up authentication is required for modifications.",
      "OAPI.Roles.FinancialAdvisor": "Financial Advisor (FA).",
      "OAPI.Roles.ManageModelsandBenchmarks":
          "Can create and modify models & benchmarks and rebalance.",
      "OAPI.Roles.ManageSLICLimitConfiguration":
          "You can update the limit configuration in liquidity management.",
      "OAPI.Roles.PartnerSupport":
          "View and manage support cases of clients in hierarchy.",
      "OAPI.Roles.RetailClient": "Retail Client.",
      "OAPI.Roles.RetailClientNotFullyFunded":
          "Retail client, but not yet fully funded.",
      "OAPI.Roles.Trader": "Trader.",
      "OAPI.Roles.ViewAnyClient": "Allows users to view all clients.",
      "OAPI.Roles.ViewAnyInstrument": "Allows users to search any instrument.",
      "OAPI.Roles.ViewModelsandBenchmarks": "Can view models & benchmarks.",
      "OAPI.Roles.ViewPII": "Access to PII data of all available clients."
    };

    return desc[key];
  }
}

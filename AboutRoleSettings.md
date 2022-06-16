Values of PrivilegedRoleSettings (portal: "what affects setting in portal")
 - Default: shows default value
 - Changed: shows value if you change setting in portal (from default)
 - NoChangeSaved: shows value if you change some other setting in portal - and save.

AdminEligible - ExpirationRule - (portal: assignment - Eligible permanent assignment)
  - Default: ExpirationRule  Setting: {"maximumGrantPeriod":"365.00:00:00","maximumGrantPeriodInMinutes":525600,"permanentAssignment":false}
  - Changed: ExpirationRule  Setting: {"permanentAssignment":true,"maximumGrantPeriodInMinutes":525600}
  - NoChangeSaved: ExpirationRule  Setting: {"permanentAssignment":false,"maximumGrantPeriodInMinutes":525600}

AdminEligible - MfaRule - (portal: ???)
  - Default: MfaRule  Setting: {"mfaRequired":false}
  - Changed: MfaRule  Setting: {"mfaRequired":false}
  - NoChangeSaved: MfaRule  Setting: {"mfaRequired":false}

AdminEligible - AttributeConditionRule - (portal: ???)
  - Default: AttributeConditionRule  Setting: {"condition":null,"conditionVersion":null,"conditionDescription":null,"enableEnforcement":false}
  - Changed: AttributeConditionRule  Setting: {"condition":null,"conditionVersion":null,"conditionDescription":null,"enableEnforcement":false}
  - NoChangeSaved: AttributeConditionRule  Setting: {"condition":null,"conditionVersion":null,"conditionDescription":null,"enableEnforcement":false}

AdminMember - ExpirationRule - (portal: assignment - permanent activeassignment)
  - Default: ExpirationRule  Setting: {"maximumGrantPeriod":"180.00:00:00","maximumGrantPeriodInMinutes":259200,"permanentAssignment":false}
  - Changed: ExpirationRule  Setting: {"permanentAssignment":true,"maximumGrantPeriodInMinutes":259200}
  - NoChangeSaved: ExpirationRule  Setting: {"permanentAssignment":false,"maximumGrantPeriodInMinutes":259200}

AdminMember - MfaRule - (portal: assignment - Eligible permanent assignment)
  - Default: MfaRule  Setting: {"mfaRequired":false}
  - Changed: MfaRule  Setting: {"mfaRequired":true}
  - NoChangeSaved: MfaRule  Setting: {"mfaRequired":false}

AdminMember - JustificationRule - (portal: assignment - Justification)
  - Default: JustificationRule  Setting: {"required":true}
  - Changed: JustificationRule  Setting: {"required":false}
  - NoChangeSaved: JustificationRule  Setting: {"required":true}

AdminMember - AttributeConditionRule - (portal: ???)
  - Default: AttributeConditionRule  Setting: {"condition":null,"conditionVersion":null,"conditionDescription":null,"enableEnforcement":false}
  - Changed: AttributeConditionRule  Setting: {"condition":null,"conditionVersion":null,"conditionDescription":null,"enableEnforcement":false}
  - NoChangeSaved: AttributeConditionRule  Setting: {"condition":null,"conditionVersion":null,"conditionDescription":null,"enableEnforcement":false}

UserEligible - AttributeConditionRule - (portal: ???)
  - Default: AttributeConditionRule  Setting: {"condition":null,"conditionVersion":null,"conditionDescription":null,"enableEnforcement":false}
  - Changed: AttributeConditionRule  Setting: {"condition":null,"conditionVersion":null,"conditionDescription":null,"enableEnforcement":false}
  - NoChangeSaved: AttributeConditionRule  Setting: {"condition":null,"conditionVersion":null,"conditionDescription":null,"enableEnforcement":false}

UserMember - ExpirationRule - (portal: assignment - Eligible permanent)
  - Default: 
  - Changed: ExpirationRule  Setting: {"permanentAssignment":true,"maximumGrantPeriodInMinutes":480}
  - NoChangeSaved: ExpirationRule  Setting: {"permanentAssignment":false,"maximumGrantPeriodInMinutes":480}

UserMember - MfaRule - (portal: activation - MFA)
  - Default: MfaRule  Setting: {"mfaRequired":false}
  - Changed: MfaRule  Setting: {"mfaRequired":true}
  - NoChangeSaved: MfaRule  Setting: {"mfaRequired":false}

UserMember - JustificationRule - (portal: activation - Justification)
  - Default: JustificationRule  Setting: {"required":true}
  - Changed: JustificationRule  Setting: {"required":false}
  - NoChangeSaved: JustificationRule  Setting: {"required":true}

UserMember - TicketingRule - (portal: activation - Ticketing)
  - Default: TicketingRule  Setting: {"ticketingRequired":false}
  - Changed: TicketingRule  Setting: {"ticketingRequired":true}
  - NoChangeSaved: TicketingRule  Setting: {"ticketingRequired":false}

UserMember - ApprovalRule - (portal: activation - Approvers)
  - Default: ApprovalRule  Setting: {"enabled":false,"isCriteriaSupported":false,"approvers":null,"businessFlowId":null,"hasNotificationPolicy":false}
  - Changed: ApprovalRule  Setting: {"Enabled":true,"IsCriteriaSupported":true,"Approvers":[{"Id":"GUID","Type":"Group","DisplayName":"ID:s displayname","PrincipalName":""}],"BusinessFlowId":"GUID","HasNotificationPolicy":true}
  - NoChangeSaved: ApprovalRule  Setting: {"Approvers":[]}

UserMember - ExpirationRule - (portal: ???)
  - Default: AcrsRule  Setting: {"acrsRequired":false,"acrs":""}
  - Changed: AcrsRule  Setting: {"acrsRequired":false,"acrs":""}
  - NoChangeSaved: AcrsRule  Setting: {"acrsRequired":false,"acrs":""}

UserMember - AttributeConditionRule - (portal: ???)
  - Default: AttributeConditionRule  Setting: {"condition":null,"conditionVersion":null,"conditionDescription":null,"enableEnforcement":false}
  - Changed: AttributeConditionRule  Setting: {"condition":null,"conditionVersion":null,"conditionDescription":null,"enableEnforcement":false}
  - NoChangeSaved: AttributeConditionRule  Setting: {"condition":null,"conditionVersion":null,"conditionDescription":null,"enableEnforcement":false}


Notification settings: these can be checked / altered through Microsoft Graph (roleSettingsv2). Its not possible through powershell at this point.
  
{
    "adminEligibleSettings": [{
            "ruleIdentifier": "ExpirationRule",
            "setting": "{\"permanentAssignment\":false,\"maximumGrantPeriodInMinutes\":525600}"
        }, {
            "ruleIdentifier": "MfaRule",
            "setting": "{\"mfaRequired\":false}"
        }, 

{
  "ruleIdentifier": "NotificationRule",
  "setting": "{\"policies\":[{\"deliveryMechanism\":\"email\",\"setting\":[{\"customreceivers\":null,\"isdefaultreceiverenabled\":true,\"notificationlevel\":2,\"recipienttype\":2},{\"customreceivers\":null,\"isdefaultreceiverenabled\":true,\"notificationlevel\":2,\"recipienttype\":0},{\"customreceivers\":null,\"isdefaultreceiverenabled\":true,\"notificationlevel\":2,\"recipienttype\":1}]}]}"

}]
}

- \"isdefaultreceiverenabled\":true --> sends message, (false donotsend)

- \"notificationlevel\":1 --> CriticalOnly
- \"notificationlevel\":2 --> All

- \"recipienttype\":2 -> Admin
- \"recipienttype\":1 -> Assignee
- \"recipienttype\":0 -> Approver

- When part of AdminEligibleSettings  -> send notifications when members are assigned as eligible
- When part of AdminMemberSettings -> send notifications when members are assigned as active 
- When part of UserEligbleSettings -> send notifications when members activate role


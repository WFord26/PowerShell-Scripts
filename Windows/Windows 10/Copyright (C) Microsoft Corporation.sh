Copyright (C) Microsoft Corporation. All rights reserved.

Install the latest PowerShell for new features and improvements! https://aka.ms/PSWindows

PS C:\Users\wford.MS> ssh msfortigate@az-fgt-a.mgmt.bnmg.net
msfortigate@az-fgt-a.mgmt.bnmg.net's password:
client_global_hostkeys_private_confirm: server gave bad signature for RSA key 0
az-FGT-A # diag deb reset
 diag deb console time en
# diag deb app sslvpn -1
# diag vpn ssl debug-filter src-addr4
az-FGT-A # # diag deb console time en

az-FGT-A # # diag deb app sslvpn -1

az-FGT-A # # diag vpn ssl debug-filter src-addr4 70.95.143.44

az-FGT-A # diag deb duration 0
Current duration is set to unlimited.

az-FGT-A # diagnose debug application fnbamd -1
Debug messages will be on for unlimited time.

az-FGT-A # diagnose debug enable

az-FGT-A # [2487] handle_req-Rcvd auth_cert req id=1804971470, len=1128, opt=0
[983] __cert_auth_ctx_init-req_id=1804971470, opt=0
[103] __cert_chg_st- 'Init'
[156] fnbamd_cert_load_certs_from_req-1 cert(s) in req.
[669] __cert_init-req_id=1804971470
[718] __cert_build_chain-req_id=1804971470
[273] fnbamd_chain_build-Chain discovery, opt 0x13, cur total 1
[291] fnbamd_chain_build-Following depth 0
[320] fnbamd_chain_build-Extend chain by system trust store. (no luck)
[162] __cert_prune-0 pruned.
[677] __cert_init-req_id=1804971470
[718] __cert_build_chain-req_id=1804971470
[273] fnbamd_chain_build-Chain discovery, opt 0x17, cur total 1
[291] fnbamd_chain_build-Following depth 0
[320] fnbamd_chain_build-Extend chain by system trust store. (no luck)
[352] fnbamd_chain_build-Extend chain by remote CA cache. (no luck)
[690] __cert_init-Depth 0.
[190] __fnbamd_CA_can_be_queried-Can CA be downloaded?0
[99] __cert_chg_st- 'Init' -> 'Validation'
[840] __cert_verify-req_id=1804971470
[841] __cert_verify-Chain is not complete.
[273] fnbamd_chain_build-Chain discovery, opt 0x7, cur total 1
[291] fnbamd_chain_build-Following depth 0
[320] fnbamd_chain_build-Extend chain by system trust store. (no luck)
[352] fnbamd_chain_build-Extend chain by remote CA cache. (no luck)
[486] fnbamd_cert_verify-Chain number:1
[500] fnbamd_cert_verify-Following cert chain depth 0
[657] fnbamd_cert_check_group_list-group list is empty, match any!
[191] __get_default_ocsp_ctx-def_ocsp_ctx=(nil), no_ocsp_query=0, ocsp_enabled=0
[876] __cert_verify_do_next-req_id=1804971470
[99] __cert_chg_st- 'Validation' -> 'Done'
[921] __cert_done-req_id=1804971470
[1654] fnbamd_auth_session_done-Session done, id=1804971470
[966] __fnbamd_cert_auth_run-Exit, req_id=1804971470
[1691] create_auth_cert_session-fnbamd_cert_auth_init returns 0, id=1804971470
[1610] auth_cert_success-id=1804971470
[1068] fnbamd_cert_auth_copy_cert_status-req_id=1804971470
[1107] fnbamd_cert_auth_copy_cert_status-Leaf cert status is unchecked.
[1124] fnbamd_cert_auth_copy_cert_status-Issuer of cert depth 0 is not detected in CMDB.
[1195] fnbamd_cert_auth_copy_cert_status-Cert st 4040, req_id=1804971470
[209] fnbamd_comm_send_result-Sending result 0 (nid 672) for req 1804971470, len=2536
[1555] destroy_auth_cert_session-id=1804971470
[1041] fnbamd_cert_auth_uninit-req_id=1804971470
[2487] handle_req-Rcvd auth_cert req id=1804971471, len=1128, opt=0
[983] __cert_auth_ctx_init-req_id=1804971471, opt=0
[103] __cert_chg_st- 'Init'
[156] fnbamd_cert_load_certs_from_req-1 cert(s) in req.
[669] __cert_init-req_id=1804971471
[718] __cert_build_chain-req_id=1804971471
[273] fnbamd_chain_build-Chain discovery, opt 0x13, cur total 1
[291] fnbamd_chain_build-Following depth 0
[320] fnbamd_chain_build-Extend chain by system trust store. (no luck)
[162] __cert_prune-0 pruned.
[677] __cert_init-req_id=1804971471
[718] __cert_build_chain-req_id=1804971471
[273] fnbamd_chain_build-Chain discovery, opt 0x17, cur total 1
[291] fnbamd_chain_build-Following depth 0
[320] fnbamd_chain_build-Extend chain by system trust store. (no luck)
[352] fnbamd_chain_build-Extend chain by remote CA cache. (no luck)
[690] __cert_init-Depth 0.
[190] __fnbamd_CA_can_be_queried-Can CA be downloaded?0
[99] __cert_chg_st- 'Init' -> 'Validation'
[840] __cert_verify-req_id=1804971471
[841] __cert_verify-Chain is not complete.
[273] fnbamd_chain_build-Chain discovery, opt 0x7, cur total 1
[291] fnbamd_chain_build-Following depth 0
[320] fnbamd_chain_build-Extend chain by system trust store. (no luck)
[352] fnbamd_chain_build-Extend chain by remote CA cache. (no luck)
[486] fnbamd_cert_verify-Chain number:1
[500] fnbamd_cert_verify-Following cert chain depth 0
[657] fnbamd_cert_check_group_list-group list is empty, match any!
[191] __get_default_ocsp_ctx-def_ocsp_ctx=(nil), no_ocsp_query=0, ocsp_enabled=0
[876] __cert_verify_do_next-req_id=1804971471
[99] __cert_chg_st- 'Validation' -> 'Done'
[921] __cert_done-req_id=1804971471
[1654] fnbamd_auth_session_done-Session done, id=1804971471
[966] __fnbamd_cert_auth_run-Exit, req_id=1804971471
[1691] create_auth_cert_session-fnbamd_cert_auth_init returns 0, id=1804971471
[1610] auth_cert_success-id=1804971471
[1068] fnbamd_cert_auth_copy_cert_status-req_id=1804971471
[1107] fnbamd_cert_auth_copy_cert_status-Leaf cert status is unchecked.
[1124] fnbamd_cert_auth_copy_cert_status-Issuer of cert depth 0 is not detected in CMDB.
[1195] fnbamd_cert_auth_copy_cert_status-Cert st 4040, req_id=1804971471
[209] fnbamd_comm_send_result-Sending result 0 (nid 672) for req 1804971471, len=2536
[1555] destroy_auth_cert_session-id=1804971471
[1041] fnbamd_cert_auth_uninit-req_id=1804971471
[2487] handle_req-Rcvd auth_cert req id=1804971472, len=1128, opt=0
[983] __cert_auth_ctx_init-req_id=1804971472, opt=0
[103] __cert_chg_st- 'Init'
[156] fnbamd_cert_load_certs_from_req-2 cert(s) in req.
[669] __cert_init-req_id=1804971472
[718] __cert_build_chain-req_id=1804971472
[273] fnbamd_chain_build-Chain discovery, opt 0x13, cur total 1
[291] fnbamd_chain_build-Following depth 0
[326] fnbamd_chain_build-Extend chain by system trust store. (good: 'CA_Cert_1')
[291] fnbamd_chain_build-Following depth 1
[326] fnbamd_chain_build-Extend chain by system trust store. (good: 'CA_Cert_2')
[291] fnbamd_chain_build-Following depth 2
[305] fnbamd_chain_build-Self-sign detected.
[99] __cert_chg_st- 'Init' -> 'Validation'
[840] __cert_verify-req_id=1804971472
[841] __cert_verify-Chain is complete.
[486] fnbamd_cert_verify-Chain number:3
[500] fnbamd_cert_verify-Following cert chain depth 0
[573] fnbamd_cert_verify-Issuer found: CA_Cert_1 (SSL_DPI opt 1)
[500] fnbamd_cert_verify-Following cert chain depth 1
[573] fnbamd_cert_verify-Issuer found: CA_Cert_2 (SSL_DPI opt 1)
[500] fnbamd_cert_verify-Following cert chain depth 2
[657] fnbamd_cert_check_group_list-group list is empty, match any!
[191] __get_default_ocsp_ctx-def_ocsp_ctx=(nil), no_ocsp_query=0, ocsp_enabled=0
[876] __cert_verify_do_next-req_id=1804971472
[99] __cert_chg_st- 'Validation' -> 'Done'
[921] __cert_done-req_id=1804971472
[1654] fnbamd_auth_session_done-Session done, id=1804971472
[966] __fnbamd_cert_auth_run-Exit, req_id=1804971472
[1691] create_auth_cert_session-fnbamd_cert_auth_init returns 0, id=1804971472
[1610] auth_cert_success-id=1804971472
[1068] fnbamd_cert_auth_copy_cert_status-req_id=1804971472
[1107] fnbamd_cert_auth_copy_cert_status-Leaf cert status is unchecked.
[1195] fnbamd_cert_auth_copy_cert_status-Cert st 2c0, req_id=1804971472
[209] fnbamd_comm_send_result-Sending result 0 (nid 672) for req 1804971472, len=2536
[1555] destroy_auth_cert_session-id=1804971472
[1041] fnbamd_cert_auth_uninit-req_id=1804971472
[1909] handle_req-Rcvd auth req 1804971473 for ifacosta in  opt=00200421 prot=11
[489] __compose_group_list_from_req-Group 'SG-VPN-AlwaysOn', type 1
[489] __compose_group_list_from_req-Group 'SG-VPN-OnDemand', type 1
[616] fnbamd_pop3_start-ifacosta
[378] radius_start-Didn't find radius servers (0)
[764] auth_tac_plus_start-Didn't find tac_plus servers (0)
[1009] __fnbamd_cfg_get_ldap_list_by_group-
[1067] __fnbamd_cfg_get_ldap_list_by_group-Loaded LDAP server 'Azure-DC01' for usergroup 'SG-VPN-AlwaysOn' (2)
[1836] fnbamd_ldap_auth_ctx_push-'Azure-DC01' is already in the ldap list.
[1067] __fnbamd_cfg_get_ldap_list_by_group-Loaded LDAP server 'Azure-DC01' for usergroup 'SG-VPN-OnDemand' (4)
[1117] fnbamd_cfg_get_ldap_list-Total ldap servers to try: 1
[1718] fnbamd_ldap_init-search filter is: sAMAccountName=ifacosta
[1728] fnbamd_ldap_init-search base is: dc=bnmg,dc=net
[115] fnbamd_dns_resolv_ex-DNS req ipv4 0xabe 'az-bu-dc01.bnmg.net'
[125] fnbamd_dns_resolv_ex-DNS req ipv6 0x2abe 'az-bu-dc01.bnmg.net'
[137] fnbamd_dns_resolv_ex-DNS maintainer started.
[480] fnbamd_cfg_get_ext_idp_list-
[454] __fnbamd_cfg_get_ext_idp_list_by_group-
[460] __fnbamd_cfg_get_ext_idp_list_by_group-Group 'SG-VPN-AlwaysOn'
[460] __fnbamd_cfg_get_ext_idp_list_by_group-Group 'SG-VPN-OnDemand'
[490] fnbamd_cfg_get_ext_idp_list-Total external identity provider servers to try: 0
[652] create_auth_session-Total 1 server(s) to try
[1950] handle_req-r=4
[247] fnbamd_dns_parse_resp-got IPv4 DNS reply, req-id=0xabe
[306] fnbamd_dns_parse_resp-req 0xabe: 10.0.4.4
[1150] __fnbamd_ldap_dns_cb-Resolved Azure-DC01:az-bu-dc01.bnmg.net to 10.0.4.4, cur stack size:1
[925] __fnbamd_ldap_get_next_addr-
[1155] __fnbamd_ldap_dns_cb-Connection starts Azure-DC01:az-bu-dc01.bnmg.net, addr 10.0.4.4
[880] __fnbamd_ldap_start_conn-Still connecting 10.0.4.4.
[1108] __ldap_connect-tcps_connect(10.0.4.4) is established.
[247] fnbamd_dns_parse_resp-got IPv6 DNS reply, req-id=0x2abe
[266] fnbamd_dns_parse_resp-req 0xabe: wrong dns format, qr=1, opcode=0, qdc=1, ancount=0
[35] __fnbamd_dns_req_del-DNS req 0xabe (0xfd4dd70) is removed. Current total: 2
[47] __fnbamd_dns_req_del-DNS maintainer stopped.
[1150] __fnbamd_ldap_dns_cb-Resolved Azure-DC01:az-bu-dc01.bnmg.net to ::, cur stack size:0
[986] __ldap_rxtx-state 1(StartTLS)
[1083] fnbamd_ldap_send-sending 31 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 1
[986] __ldap_rxtx-state 2(StartTLS resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 38
[1306] fnbamd_ldap_recv-Response len: 40, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:1, type:extended-result
[1023] fnbamd_ldap_parse_response-ret=0
[1053] __ldap_rxtx-Change state to 'Connecting'
[1108] __ldap_connect-tcps_connect(10.0.4.4) is established.
[986] __ldap_rxtx-state 3(Admin Binding)
[363] __ldap_build_bind_req-Binding to 'ldap_vpnadmin'
[1083] fnbamd_ldap_send-sending 51 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 2
[986] __ldap_rxtx-state 4(Admin Bind resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 14
[1306] fnbamd_ldap_recv-Response len: 16, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:2, type:bind
[1023] fnbamd_ldap_parse_response-ret=0
[1053] __ldap_rxtx-Change state to 'DN search'
[986] __ldap_rxtx-state 11(DN search)
[750] fnbamd_ldap_build_dn_search_req-base:'dc=bnmg,dc=net' filter:sAMAccountName=ifacosta
[1083] fnbamd_ldap_send-sending 73 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 3
[986] __ldap_rxtx-state 12(DN search resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 108
[1306] fnbamd_ldap_recv-Response len: 110, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-entry
[1023] fnbamd_ldap_parse_response-ret=0
[1226] __fnbamd_ldap_dn_entry-Get DN 'CN=Iscela Fontes-Acosta,OU=Chula Vista 2,OU=South Bay,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET'
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 72
[1306] fnbamd_ldap_recv-Response len: 74, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 72
[1306] fnbamd_ldap_recv-Response len: 74, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 56
[1306] fnbamd_ldap_recv-Response len: 58, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 72
[1306] fnbamd_ldap_recv-Response len: 74, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 14
[1306] fnbamd_ldap_recv-Response len: 16, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-result
[1023] fnbamd_ldap_parse_response-ret=0
[1053] __ldap_rxtx-Change state to 'User Binding'
[986] __ldap_rxtx-state 5(User Binding)
[596] fnbamd_ldap_build_userbind_req-Trying DN 'CN=Iscela Fontes-Acosta,OU=Chula Vista 2,OU=South Bay,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET'
[363] __ldap_build_bind_req-Binding to 'CN=Iscela Fontes-Acosta,OU=Chula Vista 2,OU=South Bay,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET'
[1083] fnbamd_ldap_send-sending 147 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 4
[986] __ldap_rxtx-state 6(User Bind resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 14
[1306] fnbamd_ldap_recv-Response len: 16, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:4, type:bind
[1023] fnbamd_ldap_parse_response-ret=0
[1053] __ldap_rxtx-Change state to 'Attr query'
[986] __ldap_rxtx-state 7(Attr query)
[649] fnbamd_ldap_build_attr_search_req-Adding attr 'memberOf'
[661] fnbamd_ldap_build_attr_search_req-base:'CN=Iscela Fontes-Acosta,OU=Chula Vista 2,OU=South Bay,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET' filter:cn=*
[1083] fnbamd_ldap_send-sending 171 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 5
[986] __ldap_rxtx-state 8(Attr query resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 920
[1306] fnbamd_ldap_recv-Response len: 922, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:5, type:search-entry
[1023] fnbamd_ldap_parse_response-ret=0
[556] __get_member_of_groups-Get the memberOf groups.
[522] __retrieve_group_values-Get the memberOf groups.
[532] __retrieve_group_values- attr='memberOf', found 10 values
[542] __retrieve_group_values-val[0]='CN=Clinical Staff,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[1]='CN=Clinical Staff and Physicians,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[2]='CN=Chula Vista 2,OU=Chula Vista 2,OU=South Bay,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[3]='CN=SG-Medical Assistants and Front Desk,OU=Security Groups,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[4]='CN=gp_sslvpn,OU=Security Groups,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[5]='CN=FS-Ace-RW,OU=Ace,OU=Executive Square,OU=Corporate,OU=BU,OU=Organizations,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[6]='CN=SG-RedirectedFolders,OU=Security Groups,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[7]='CN=Centricity - Beginning Scheduling,OU=Centricity - Security Groups,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[8]='CN=RDP-Users,CN=Users,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[9]='CN=Chula Vista,OU=Chula Vista 1,OU=South Bay,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET'
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 14
[1306] fnbamd_ldap_recv-Response len: 16, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:5, type:search-result
[1023] fnbamd_ldap_parse_response-ret=0
[1306] __fnbamd_ldap_attr_next-Entering CHKPRIMARYGRP state
[1053] __ldap_rxtx-Change state to 'Primary group query'
[986] __ldap_rxtx-state 13(Primary group query)
[685] fnbamd_ldap_build_primary_grp_search_req-starting primary group check...
[689] fnbamd_ldap_build_primary_grp_search_req-number of sub auths 5
[707] fnbamd_ldap_build_primary_grp_search_req-base:'dc=bnmg,dc=net' filter:(&(objectclass=group)(objectSid=\01\05\00\00\00\00\00\05\15\00\00\00\93\40\b0\c4\54\2c\9d\c4\92\7a\25\74\01\02\00\00))
[1083] fnbamd_ldap_send-sending 118 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 6
[986] __ldap_rxtx-state 14(Primary group query resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 107
[1306] fnbamd_ldap_recv-Response len: 109, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:6, type:search-entry
[1023] fnbamd_ldap_parse_response-ret=0
[472] __get_one_group-group: CN=Domain Users,CN=Users,DC=BNMG,DC=NET
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 72
[1306] fnbamd_ldap_recv-Response len: 74, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:6, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 72
[1306] fnbamd_ldap_recv-Response len: 74, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:6, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 56
[1306] fnbamd_ldap_recv-Response len: 58, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:6, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 72
[1306] fnbamd_ldap_recv-Response len: 74, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:6, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 14
[1306] fnbamd_ldap_recv-Response len: 16, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:6, type:search-result
[1023] fnbamd_ldap_parse_response-ret=0
[1431] __fnbamd_ldap_primary_grp_next-Auth accepted
[1053] __ldap_rxtx-Change state to 'Done'
[986] __ldap_rxtx-state 23(Done)
[1083] fnbamd_ldap_send-sending 7 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 7
[785] __ldap_done-svr 'Azure-DC01'
[755] __ldap_destroy-
[724] __ldap_stop-Conn with 10.0.4.4 destroyed.
[2831] fnbamd_ldap_result-Result for ldap svr az-bu-dc01.bnmg.net(Azure-DC01) is SUCCESS
[401] ldap_copy_grp_list-copied CN=Clinical Staff,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=Clinical Staff and Physicians,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=Chula Vista 2,OU=Chula Vista 2,OU=South Bay,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=SG-Medical Assistants and Front Desk,OU=Security Groups,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=gp_sslvpn,OU=Security Groups,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=FS-Ace-RW,OU=Ace,OU=Executive Square,OU=Corporate,OU=BU,OU=Organizations,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=SG-RedirectedFolders,OU=Security Groups,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=Centricity - Beginning Scheduling,OU=Centricity - Security Groups,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=RDP-Users,CN=Users,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=Chula Vista,OU=Chula Vista 1,OU=South Bay,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=Domain Users,CN=Users,DC=BNMG,DC=NET
[1623] fnbam_user_auth_group_match-req id: 1804971473, server: Azure-DC01, local auth: 0, dn match: 1
[2839] fnbamd_ldap_result-Failed group matching
[209] fnbamd_comm_send_result-Sending result 1 (nid 0) for req 1804971473, len=3271
[808] destroy_auth_session-delete session 1804971473
[755] __ldap_destroy-
[1764] fnbamd_ldap_auth_ctx_free-Freeing 'Azure-DC01' ctx
[1086] fnbamd_ext_idps_destroy-
[2487] handle_req-Rcvd auth_cert req id=1804971474, len=1128, opt=0
[983] __cert_auth_ctx_init-req_id=1804971474, opt=0
[103] __cert_chg_st- 'Init'
[156] fnbamd_cert_load_certs_from_req-2 cert(s) in req.
[669] __cert_init-req_id=1804971474
[718] __cert_build_chain-req_id=1804971474
[273] fnbamd_chain_build-Chain discovery, opt 0x13, cur total 1
[291] fnbamd_chain_build-Following depth 0
[326] fnbamd_chain_build-Extend chain by system trust store. (good: 'CA_Cert_1')
[291] fnbamd_chain_build-Following depth 1
[326] fnbamd_chain_build-Extend chain by system trust store. (good: 'CA_Cert_2')
[291] fnbamd_chain_build-Following depth 2
[305] fnbamd_chain_build-Self-sign detected.
[99] __cert_chg_st- 'Init' -> 'Validation'
[840] __cert_verify-req_id=1804971474
[841] __cert_verify-Chain is complete.
[486] fnbamd_cert_verify-Chain number:3
[500] fnbamd_cert_verify-Following cert chain depth 0
[573] fnbamd_cert_verify-Issuer found: CA_Cert_1 (SSL_DPI opt 1)
[500] fnbamd_cert_verify-Following cert chain depth 1
[573] fnbamd_cert_verify-Issuer found: CA_Cert_2 (SSL_DPI opt 1)
[500] fnbamd_cert_verify-Following cert chain depth 2
[657] fnbamd_cert_check_group_list-group list is empty, match any!
[191] __get_default_ocsp_ctx-def_ocsp_ctx=(nil), no_ocsp_query=0, ocsp_enabled=0
[876] __cert_verify_do_next-req_id=1804971474
[99] __cert_chg_st- 'Validation' -> 'Done'
[921] __cert_done-req_id=1804971474
[1654] fnbamd_auth_session_done-Session done, id=1804971474
[966] __fnbamd_cert_auth_run-Exit, req_id=1804971474
[1691] create_auth_cert_session-fnbamd_cert_auth_init returns 0, id=1804971474
[1610] auth_cert_success-id=1804971474
[1068] fnbamd_cert_auth_copy_cert_status-req_id=1804971474
[1107] fnbamd_cert_auth_copy_cert_status-Leaf cert status is unchecked.
[1195] fnbamd_cert_auth_copy_cert_status-Cert st 2c0, req_id=1804971474
[209] fnbamd_comm_send_result-Sending result 0 (nid 672) for req 1804971474, len=2536
[1555] destroy_auth_cert_session-id=1804971474
[1041] fnbamd_cert_auth_uninit-req_id=1804971474
[1909] handle_req-Rcvd auth req 1804971475 for ifacosta in  opt=00200421 prot=11
[489] __compose_group_list_from_req-Group 'SG-VPN-AlwaysOn', type 1
[489] __compose_group_list_from_req-Group 'SG-VPN-OnDemand', type 1
[616] fnbamd_pop3_start-ifacosta
[378] radius_start-Didn't find radius servers (0)
[764] auth_tac_plus_start-Didn't find tac_plus servers (0)
[1009] __fnbamd_cfg_get_ldap_list_by_group-
[1067] __fnbamd_cfg_get_ldap_list_by_group-Loaded LDAP server 'Azure-DC01' for usergroup 'SG-VPN-AlwaysOn' (2)
[1836] fnbamd_ldap_auth_ctx_push-'Azure-DC01' is already in the ldap list.
[1067] __fnbamd_cfg_get_ldap_list_by_group-Loaded LDAP server 'Azure-DC01' for usergroup 'SG-VPN-OnDemand' (4)
[1117] fnbamd_cfg_get_ldap_list-Total ldap servers to try: 1
[1718] fnbamd_ldap_init-search filter is: sAMAccountName=ifacosta
[1728] fnbamd_ldap_init-search base is: dc=bnmg,dc=net
[115] fnbamd_dns_resolv_ex-DNS req ipv4 0xabf 'az-bu-dc01.bnmg.net'
[125] fnbamd_dns_resolv_ex-DNS req ipv6 0x2abf 'az-bu-dc01.bnmg.net'
[137] fnbamd_dns_resolv_ex-DNS maintainer started.
[480] fnbamd_cfg_get_ext_idp_list-
[454] __fnbamd_cfg_get_ext_idp_list_by_group-
[460] __fnbamd_cfg_get_ext_idp_list_by_group-Group 'SG-VPN-AlwaysOn'
[460] __fnbamd_cfg_get_ext_idp_list_by_group-Group 'SG-VPN-OnDemand'
[490] fnbamd_cfg_get_ext_idp_list-Total external identity provider servers to try: 0
[652] create_auth_session-Total 1 server(s) to try
[1950] handle_req-r=4
[247] fnbamd_dns_parse_resp-got IPv4 DNS reply, req-id=0xabf
[306] fnbamd_dns_parse_resp-req 0xabf: 10.0.4.4
[1150] __fnbamd_ldap_dns_cb-Resolved Azure-DC01:az-bu-dc01.bnmg.net to 10.0.4.4, cur stack size:1
[925] __fnbamd_ldap_get_next_addr-
[1155] __fnbamd_ldap_dns_cb-Connection starts Azure-DC01:az-bu-dc01.bnmg.net, addr 10.0.4.4
[880] __fnbamd_ldap_start_conn-Still connecting 10.0.4.4.
[1108] __ldap_connect-tcps_connect(10.0.4.4) is established.
[247] fnbamd_dns_parse_resp-got IPv6 DNS reply, req-id=0x2abf
[266] fnbamd_dns_parse_resp-req 0xabf: wrong dns format, qr=1, opcode=0, qdc=1, ancount=0
[35] __fnbamd_dns_req_del-DNS req 0xabf (0xfd4dd70) is removed. Current total: 2
[47] __fnbamd_dns_req_del-DNS maintainer stopped.
[1150] __fnbamd_ldap_dns_cb-Resolved Azure-DC01:az-bu-dc01.bnmg.net to ::, cur stack size:0
[986] __ldap_rxtx-state 1(StartTLS)
[1083] fnbamd_ldap_send-sending 31 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 1
[986] __ldap_rxtx-state 2(StartTLS resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 38
[1306] fnbamd_ldap_recv-Response len: 40, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:1, type:extended-result
[1023] fnbamd_ldap_parse_response-ret=0
[1053] __ldap_rxtx-Change state to 'Connecting'
[1108] __ldap_connect-tcps_connect(10.0.4.4) is established.
[986] __ldap_rxtx-state 3(Admin Binding)
[363] __ldap_build_bind_req-Binding to 'ldap_vpnadmin'
[1083] fnbamd_ldap_send-sending 51 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 2
[986] __ldap_rxtx-state 4(Admin Bind resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 14
[1306] fnbamd_ldap_recv-Response len: 16, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:2, type:bind
[1023] fnbamd_ldap_parse_response-ret=0
[1053] __ldap_rxtx-Change state to 'DN search'
[986] __ldap_rxtx-state 11(DN search)
[750] fnbamd_ldap_build_dn_search_req-base:'dc=bnmg,dc=net' filter:sAMAccountName=ifacosta
[1083] fnbamd_ldap_send-sending 73 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 3
[986] __ldap_rxtx-state 12(DN search resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 108
[1306] fnbamd_ldap_recv-Response len: 110, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-entry
[1023] fnbamd_ldap_parse_response-ret=0
[1226] __fnbamd_ldap_dn_entry-Get DN 'CN=Iscela Fontes-Acosta,OU=Chula Vista 2,OU=South Bay,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET'
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 72
[1306] fnbamd_ldap_recv-Response len: 74, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 72
[1306] fnbamd_ldap_recv-Response len: 74, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 56
[1306] fnbamd_ldap_recv-Response len: 58, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 72
[1306] fnbamd_ldap_recv-Response len: 74, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 14
[1306] fnbamd_ldap_recv-Response len: 16, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-result
[1023] fnbamd_ldap_parse_response-ret=0
[1053] __ldap_rxtx-Change state to 'User Binding'
[986] __ldap_rxtx-state 5(User Binding)
[596] fnbamd_ldap_build_userbind_req-Trying DN 'CN=Iscela Fontes-Acosta,OU=Chula Vista 2,OU=South Bay,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET'
[363] __ldap_build_bind_req-Binding to 'CN=Iscela Fontes-Acosta,OU=Chula Vista 2,OU=South Bay,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET'
[1083] fnbamd_ldap_send-sending 147 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 4
[986] __ldap_rxtx-state 6(User Bind resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 14
[1306] fnbamd_ldap_recv-Response len: 16, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:4, type:bind
[1023] fnbamd_ldap_parse_response-ret=0
[1053] __ldap_rxtx-Change state to 'Attr query'
[986] __ldap_rxtx-state 7(Attr query)
[649] fnbamd_ldap_build_attr_search_req-Adding attr 'memberOf'
[661] fnbamd_ldap_build_attr_search_req-base:'CN=Iscela Fontes-Acosta,OU=Chula Vista 2,OU=South Bay,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET' filter:cn=*
[1083] fnbamd_ldap_send-sending 171 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 5
[986] __ldap_rxtx-state 8(Attr query resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 920
[1306] fnbamd_ldap_recv-Response len: 922, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:5, type:search-entry
[1023] fnbamd_ldap_parse_response-ret=0
[556] __get_member_of_groups-Get the memberOf groups.
[522] __retrieve_group_values-Get the memberOf groups.
[532] __retrieve_group_values- attr='memberOf', found 10 values
[542] __retrieve_group_values-val[0]='CN=Clinical Staff,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[1]='CN=Clinical Staff and Physicians,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[2]='CN=Chula Vista 2,OU=Chula Vista 2,OU=South Bay,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[3]='CN=SG-Medical Assistants and Front Desk,OU=Security Groups,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[4]='CN=gp_sslvpn,OU=Security Groups,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[5]='CN=FS-Ace-RW,OU=Ace,OU=Executive Square,OU=Corporate,OU=BU,OU=Organizations,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[6]='CN=SG-RedirectedFolders,OU=Security Groups,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[7]='CN=Centricity - Beginning Scheduling,OU=Centricity - Security Groups,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[8]='CN=RDP-Users,CN=Users,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[9]='CN=Chula Vista,OU=Chula Vista 1,OU=South Bay,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET'
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 14
[1306] fnbamd_ldap_recv-Response len: 16, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:5, type:search-result
[1023] fnbamd_ldap_parse_response-ret=0
[1306] __fnbamd_ldap_attr_next-Entering CHKPRIMARYGRP state
[1053] __ldap_rxtx-Change state to 'Primary group query'
[986] __ldap_rxtx-state 13(Primary group query)
[685] fnbamd_ldap_build_primary_grp_search_req-starting primary group check...
[689] fnbamd_ldap_build_primary_grp_search_req-number of sub auths 5
[707] fnbamd_ldap_build_primary_grp_search_req-base:'dc=bnmg,dc=net' filter:(&(objectclass=group)(objectSid=\01\05\00\00\00\00\00\05\15\00\00\00\93\40\b0\c4\54\2c\9d\c4\92\7a\25\74\01\02\00\00))
[1083] fnbamd_ldap_send-sending 118 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 6
[986] __ldap_rxtx-state 14(Primary group query resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 107
[1306] fnbamd_ldap_recv-Response len: 109, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:6, type:search-entry
[1023] fnbamd_ldap_parse_response-ret=0
[472] __get_one_group-group: CN=Domain Users,CN=Users,DC=BNMG,DC=NET
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 72
[1306] fnbamd_ldap_recv-Response len: 74, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:6, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 72
[1306] fnbamd_ldap_recv-Response len: 74, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:6, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 56
[1306] fnbamd_ldap_recv-Response len: 58, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:6, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 72
[1306] fnbamd_ldap_recv-Response len: 74, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:6, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 14
[1306] fnbamd_ldap_recv-Response len: 16, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:6, type:search-result
[1023] fnbamd_ldap_parse_response-ret=0
[1431] __fnbamd_ldap_primary_grp_next-Auth accepted
[1053] __ldap_rxtx-Change state to 'Done'
[986] __ldap_rxtx-state 23(Done)
[1083] fnbamd_ldap_send-sending 7 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 7
[785] __ldap_done-svr 'Azure-DC01'
[755] __ldap_destroy-
[724] __ldap_stop-Conn with 10.0.4.4 destroyed.
[2831] fnbamd_ldap_result-Result for ldap svr az-bu-dc01.bnmg.net(Azure-DC01) is SUCCESS
[401] ldap_copy_grp_list-copied CN=Clinical Staff,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=Clinical Staff and Physicians,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=Chula Vista 2,OU=Chula Vista 2,OU=South Bay,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=SG-Medical Assistants and Front Desk,OU=Security Groups,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=gp_sslvpn,OU=Security Groups,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=FS-Ace-RW,OU=Ace,OU=Executive Square,OU=Corporate,OU=BU,OU=Organizations,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=SG-RedirectedFolders,OU=Security Groups,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=Centricity - Beginning Scheduling,OU=Centricity - Security Groups,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=RDP-Users,CN=Users,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=Chula Vista,OU=Chula Vista 1,OU=South Bay,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=Domain Users,CN=Users,DC=BNMG,DC=NET
[1623] fnbam_user_auth_group_match-req id: 1804971475, server: Azure-DC01, local auth: 0, dn match: 1
[2839] fnbamd_ldap_result-Failed group matching
[209] fnbamd_comm_send_result-Sending result 1 (nid 0) for req 1804971475, len=3271
[808] destroy_auth_session-delete session 1804971475
[755] __ldap_destroy-
[1764] fnbamd_ldap_auth_ctx_free-Freeing 'Azure-DC01' ctx
[1086] fnbamd_ext_idps_destroy-
[208] __fnbamd_remote_ca_refresh-
[2487] handle_req-Rcvd auth_cert req id=1804971476, len=1128, opt=0
[983] __cert_auth_ctx_init-req_id=1804971476, opt=0
[103] __cert_chg_st- 'Init'
[156] fnbamd_cert_load_certs_from_req-2 cert(s) in req.
[669] __cert_init-req_id=1804971476
[718] __cert_build_chain-req_id=1804971476
[273] fnbamd_chain_build-Chain discovery, opt 0x13, cur total 1
[291] fnbamd_chain_build-Following depth 0
[326] fnbamd_chain_build-Extend chain by system trust store. (good: 'CA_Cert_1')
[291] fnbamd_chain_build-Following depth 1
[326] fnbamd_chain_build-Extend chain by system trust store. (good: 'CA_Cert_2')
[291] fnbamd_chain_build-Following depth 2
[305] fnbamd_chain_build-Self-sign detected.
[99] __cert_chg_st- 'Init' -> 'Validation'
[840] __cert_verify-req_id=1804971476
[841] __cert_verify-Chain is complete.
[486] fnbamd_cert_verify-Chain number:3
[500] fnbamd_cert_verify-Following cert chain depth 0
[573] fnbamd_cert_verify-Issuer found: CA_Cert_1 (SSL_DPI opt 1)
[500] fnbamd_cert_verify-Following cert chain depth 1
[573] fnbamd_cert_verify-Issuer found: CA_Cert_2 (SSL_DPI opt 1)
[500] fnbamd_cert_verify-Following cert chain depth 2
[657] fnbamd_cert_check_group_list-group list is empty, match any!
[191] __get_default_ocsp_ctx-def_ocsp_ctx=(nil), no_ocsp_query=0, ocsp_enabled=0
[876] __cert_verify_do_next-req_id=1804971476
[99] __cert_chg_st- 'Validation' -> 'Done'
[921] __cert_done-req_id=1804971476
[1654] fnbamd_auth_session_done-Session done, id=1804971476
[966] __fnbamd_cert_auth_run-Exit, req_id=1804971476
[1691] create_auth_cert_session-fnbamd_cert_auth_init returns 0, id=1804971476
[1610] auth_cert_success-id=1804971476
[1068] fnbamd_cert_auth_copy_cert_status-req_id=1804971476
[1107] fnbamd_cert_auth_copy_cert_status-Leaf cert status is unchecked.
[1195] fnbamd_cert_auth_copy_cert_status-Cert st 2c0, req_id=1804971476
[209] fnbamd_comm_send_result-Sending result 0 (nid 672) for req 1804971476, len=2536
[1555] destroy_auth_cert_session-id=1804971476
[1041] fnbamd_cert_auth_uninit-req_id=1804971476
[1909] handle_req-Rcvd auth req 1804971477 for lvpalmes in  opt=00200421 prot=11
[489] __compose_group_list_from_req-Group 'SG-VPN-AlwaysOn', type 1
[489] __compose_group_list_from_req-Group 'SG-VPN-OnDemand', type 1
[616] fnbamd_pop3_start-lvpalmes
[378] radius_start-Didn't find radius servers (0)
[764] auth_tac_plus_start-Didn't find tac_plus servers (0)
[1009] __fnbamd_cfg_get_ldap_list_by_group-
[1067] __fnbamd_cfg_get_ldap_list_by_group-Loaded LDAP server 'Azure-DC01' for usergroup 'SG-VPN-AlwaysOn' (2)
[1836] fnbamd_ldap_auth_ctx_push-'Azure-DC01' is already in the ldap list.
[1067] __fnbamd_cfg_get_ldap_list_by_group-Loaded LDAP server 'Azure-DC01' for usergroup 'SG-VPN-OnDemand' (4)
[1117] fnbamd_cfg_get_ldap_list-Total ldap servers to try: 1
[1718] fnbamd_ldap_init-search filter is: sAMAccountName=lvpalmes
[1728] fnbamd_ldap_init-search base is: dc=bnmg,dc=net
[115] fnbamd_dns_resolv_ex-DNS req ipv4 0xac0 'az-bu-dc01.bnmg.net'
[125] fnbamd_dns_resolv_ex-DNS req ipv6 0x2ac0 'az-bu-dc01.bnmg.net'
[137] fnbamd_dns_resolv_ex-DNS maintainer started.
[480] fnbamd_cfg_get_ext_idp_list-
[454] __fnbamd_cfg_get_ext_idp_list_by_group-
[460] __fnbamd_cfg_get_ext_idp_list_by_group-Group 'SG-VPN-AlwaysOn'
[460] __fnbamd_cfg_get_ext_idp_list_by_group-Group 'SG-VPN-OnDemand'
[490] fnbamd_cfg_get_ext_idp_list-Total external identity provider servers to try: 0
[652] create_auth_session-Total 1 server(s) to try
[1950] handle_req-r=4
[247] fnbamd_dns_parse_resp-got IPv4 DNS reply, req-id=0xac0
[306] fnbamd_dns_parse_resp-req 0xac0: 10.0.4.4
[1150] __fnbamd_ldap_dns_cb-Resolved Azure-DC01:az-bu-dc01.bnmg.net to 10.0.4.4, cur stack size:1
[925] __fnbamd_ldap_get_next_addr-
[1155] __fnbamd_ldap_dns_cb-Connection starts Azure-DC01:az-bu-dc01.bnmg.net, addr 10.0.4.4
[880] __fnbamd_ldap_start_conn-Still connecting 10.0.4.4.
[247] fnbamd_dns_parse_resp-got IPv6 DNS reply, req-id=0x2ac0
[266] fnbamd_dns_parse_resp-req 0xac0: wrong dns format, qr=1, opcode=0, qdc=1, ancount=0
[35] __fnbamd_dns_req_del-DNS req 0xac0 (0xfd4dd70) is removed. Current total: 2
[47] __fnbamd_dns_req_del-DNS maintainer stopped.
[1150] __fnbamd_ldap_dns_cb-Resolved Azure-DC01:az-bu-dc01.bnmg.net to ::, cur stack size:0
[1108] __ldap_connect-tcps_connect(10.0.4.4) is established.
[986] __ldap_rxtx-state 1(StartTLS)
[1083] fnbamd_ldap_send-sending 31 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 1
[986] __ldap_rxtx-state 2(StartTLS resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 38
[1306] fnbamd_ldap_recv-Response len: 40, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:1, type:extended-result
[1023] fnbamd_ldap_parse_response-ret=0
[1053] __ldap_rxtx-Change state to 'Connecting'
[1108] __ldap_connect-tcps_connect(10.0.4.4) is established.
[986] __ldap_rxtx-state 3(Admin Binding)
[363] __ldap_build_bind_req-Binding to 'ldap_vpnadmin'
[1083] fnbamd_ldap_send-sending 51 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 2
[986] __ldap_rxtx-state 4(Admin Bind resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 14
[1306] fnbamd_ldap_recv-Response len: 16, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:2, type:bind
[1023] fnbamd_ldap_parse_response-ret=0
[1053] __ldap_rxtx-Change state to 'DN search'
[986] __ldap_rxtx-state 11(DN search)
[750] fnbamd_ldap_build_dn_search_req-base:'dc=bnmg,dc=net' filter:sAMAccountName=lvpalmes
[1083] fnbamd_ldap_send-sending 73 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 3
[986] __ldap_rxtx-state 12(DN search resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 104
[1306] fnbamd_ldap_recv-Response len: 106, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-entry
[1023] fnbamd_ldap_parse_response-ret=0
[1226] __fnbamd_ldap_dn_entry-Get DN 'CN=LV Palmes,OU=HR,OU=Executive Square,OU=Corporate,OU=BU,OU=Organizations,DC=BNMG,DC=NET'
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 72
[1306] fnbamd_ldap_recv-Response len: 74, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 72
[1306] fnbamd_ldap_recv-Response len: 74, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 56
[1306] fnbamd_ldap_recv-Response len: 58, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 72
[1306] fnbamd_ldap_recv-Response len: 74, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 14
[1306] fnbamd_ldap_recv-Response len: 16, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-result
[1023] fnbamd_ldap_parse_response-ret=0
[1053] __ldap_rxtx-Change state to 'User Binding'
[986] __ldap_rxtx-state 5(User Binding)
[596] fnbamd_ldap_build_userbind_req-Trying DN 'CN=LV Palmes,OU=HR,OU=Executive Square,OU=Corporate,OU=BU,OU=Organizations,DC=BNMG,DC=NET'
[363] __ldap_build_bind_req-Binding to 'CN=LV Palmes,OU=HR,OU=Executive Square,OU=Corporate,OU=BU,OU=Organizations,DC=BNMG,DC=NET'
[1083] fnbamd_ldap_send-sending 147 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 4
[986] __ldap_rxtx-state 6(User Bind resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 102
[1306] fnbamd_ldap_recv-Response len: 104, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:4, type:bind
[1009] fnbamd_ldap_parse_response-Error 49(80090308: LdapErr: DSID-0C090569, comment: AcceptSecurityContext error, data 532, v4563)
[1023] fnbamd_ldap_parse_response-ret=49
[1053] __ldap_rxtx-Change state to 'Done'
[986] __ldap_rxtx-state 23(Done)
[1083] fnbamd_ldap_send-sending 7 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 5
[785] __ldap_done-svr 'Azure-DC01'
[755] __ldap_destroy-
[724] __ldap_stop-Conn with 10.0.4.4 destroyed.
[209] fnbamd_comm_send_result-Sending result 1 (nid 0) for req 1804971477, len=2544
[808] destroy_auth_session-delete session 1804971477
[755] __ldap_destroy-
[1764] fnbamd_ldap_auth_ctx_free-Freeing 'Azure-DC01' ctx
[1086] fnbamd_ext_idps_destroy-
[2487] handle_req-Rcvd auth_cert req id=1804971478, len=1128, opt=0
[983] __cert_auth_ctx_init-req_id=1804971478, opt=0
[103] __cert_chg_st- 'Init'
[156] fnbamd_cert_load_certs_from_req-1 cert(s) in req.
[669] __cert_init-req_id=1804971478
[718] __cert_build_chain-req_id=1804971478
[273] fnbamd_chain_build-Chain discovery, opt 0x13, cur total 1
[291] fnbamd_chain_build-Following depth 0
[320] fnbamd_chain_build-Extend chain by system trust store. (no luck)
[162] __cert_prune-0 pruned.
[677] __cert_init-req_id=1804971478
[718] __cert_build_chain-req_id=1804971478
[273] fnbamd_chain_build-Chain discovery, opt 0x17, cur total 1
[291] fnbamd_chain_build-Following depth 0
[320] fnbamd_chain_build-Extend chain by system trust store. (no luck)
[352] fnbamd_chain_build-Extend chain by remote CA cache. (no luck)
[690] __cert_init-Depth 0.
[190] __fnbamd_CA_can_be_queried-Can CA be downloaded?0
[99] __cert_chg_st- 'Init' -> 'Validation'
[840] __cert_verify-req_id=1804971478
[841] __cert_verify-Chain is not complete.
[273] fnbamd_chain_build-Chain discovery, opt 0x7, cur total 1
[291] fnbamd_chain_build-Following depth 0
[320] fnbamd_chain_build-Extend chain by system trust store. (no luck)
[352] fnbamd_chain_build-Extend chain by remote CA cache. (no luck)
[486] fnbamd_cert_verify-Chain number:1
[500] fnbamd_cert_verify-Following cert chain depth 0
[657] fnbamd_cert_check_group_list-group list is empty, match any!
[191] __get_default_ocsp_ctx-def_ocsp_ctx=(nil), no_ocsp_query=0, ocsp_enabled=0
[876] __cert_verify_do_next-req_id=1804971478
[99] __cert_chg_st- 'Validation' -> 'Done'
[921] __cert_done-req_id=1804971478
[1654] fnbamd_auth_session_done-Session done, id=1804971478
[966] __fnbamd_cert_auth_run-Exit, req_id=1804971478
[1691] create_auth_cert_session-fnbamd_cert_auth_init returns 0, id=1804971478
[1610] auth_cert_success-id=1804971478
[1068] fnbamd_cert_auth_copy_cert_status-req_id=1804971478
[1107] fnbamd_cert_auth_copy_cert_status-Leaf cert status is unchecked.
[1124] fnbamd_cert_auth_copy_cert_status-Issuer of cert depth 0 is not detected in CMDB.
[1195] fnbamd_cert_auth_copy_cert_status-Cert st 4040, req_id=1804971478
[209] fnbamd_comm_send_result-Sending result 0 (nid 672) for req 1804971478, len=2536
[1555] destroy_auth_cert_session-id=1804971478
[1041] fnbamd_cert_auth_uninit-req_id=1804971478
[2487] handle_req-Rcvd auth_cert req id=1804971479, len=1128, opt=0
[983] __cert_auth_ctx_init-req_id=1804971479, opt=0
[103] __cert_chg_st- 'Init'
[156] fnbamd_cert_load_certs_from_req-2 cert(s) in req.
[669] __cert_init-req_id=1804971479
[718] __cert_build_chain-req_id=1804971479
[273] fnbamd_chain_build-Chain discovery, opt 0x13, cur total 1
[291] fnbamd_chain_build-Following depth 0
[326] fnbamd_chain_build-Extend chain by system trust store. (good: 'CA_Cert_1')
[291] fnbamd_chain_build-Following depth 1
[326] fnbamd_chain_build-Extend chain by system trust store. (good: 'CA_Cert_2')
[291] fnbamd_chain_build-Following depth 2
[305] fnbamd_chain_build-Self-sign detected.
[99] __cert_chg_st- 'Init' -> 'Validation'
[840] __cert_verify-req_id=1804971479
[841] __cert_verify-Chain is complete.
[486] fnbamd_cert_verify-Chain number:3
[500] fnbamd_cert_verify-Following cert chain depth 0
[573] fnbamd_cert_verify-Issuer found: CA_Cert_1 (SSL_DPI opt 1)
[500] fnbamd_cert_verify-Following cert chain depth 1
[573] fnbamd_cert_verify-Issuer found: CA_Cert_2 (SSL_DPI opt 1)
[500] fnbamd_cert_verify-Following cert chain depth 2
[657] fnbamd_cert_check_group_list-group list is empty, match any!
[191] __get_default_ocsp_ctx-def_ocsp_ctx=(nil), no_ocsp_query=0, ocsp_enabled=0
[876] __cert_verify_do_next-req_id=1804971479
[99] __cert_chg_st- 'Validation' -> 'Done'
[921] __cert_done-req_id=1804971479
[1654] fnbamd_auth_session_done-Session done, id=1804971479
[966] __fnbamd_cert_auth_run-Exit, req_id=1804971479
[1691] create_auth_cert_session-fnbamd_cert_auth_init returns 0, id=1804971479
[1610] auth_cert_success-id=1804971479
[1068] fnbamd_cert_auth_copy_cert_status-req_id=1804971479
[1107] fnbamd_cert_auth_copy_cert_status-Leaf cert status is unchecked.
[1195] fnbamd_cert_auth_copy_cert_status-Cert st 2c0, req_id=1804971479
[209] fnbamd_comm_send_result-Sending result 0 (nid 672) for req 1804971479, len=2536
[1555] destroy_auth_cert_session-id=1804971479
[1041] fnbamd_cert_auth_uninit-req_id=1804971479
[1909] handle_req-Rcvd auth req 1804971480 for ifacosta in  opt=00200421 prot=11
[489] __compose_group_list_from_req-Group 'SG-VPN-AlwaysOn', type 1
[489] __compose_group_list_from_req-Group 'SG-VPN-OnDemand', type 1
[616] fnbamd_pop3_start-ifacosta
[378] radius_start-Didn't find radius servers (0)
[764] auth_tac_plus_start-Didn't find tac_plus servers (0)
[1009] __fnbamd_cfg_get_ldap_list_by_group-
[1067] __fnbamd_cfg_get_ldap_list_by_group-Loaded LDAP server 'Azure-DC01' for usergroup 'SG-VPN-AlwaysOn' (2)
[1836] fnbamd_ldap_auth_ctx_push-'Azure-DC01' is already in the ldap list.
[1067] __fnbamd_cfg_get_ldap_list_by_group-Loaded LDAP server 'Azure-DC01' for usergroup 'SG-VPN-OnDemand' (4)
[1117] fnbamd_cfg_get_ldap_list-Total ldap servers to try: 1
[1718] fnbamd_ldap_init-search filter is: sAMAccountName=ifacosta
[1728] fnbamd_ldap_init-search base is: dc=bnmg,dc=net
[115] fnbamd_dns_resolv_ex-DNS req ipv4 0xac1 'az-bu-dc01.bnmg.net'
[125] fnbamd_dns_resolv_ex-DNS req ipv6 0x2ac1 'az-bu-dc01.bnmg.net'
[137] fnbamd_dns_resolv_ex-DNS maintainer started.
[480] fnbamd_cfg_get_ext_idp_list-
[454] __fnbamd_cfg_get_ext_idp_list_by_group-
[460] __fnbamd_cfg_get_ext_idp_list_by_group-Group 'SG-VPN-AlwaysOn'
[460] __fnbamd_cfg_get_ext_idp_list_by_group-Group 'SG-VPN-OnDemand'
[490] fnbamd_cfg_get_ext_idp_list-Total external identity provider servers to try: 0
[652] create_auth_session-Total 1 server(s) to try
[1950] handle_req-r=4
[247] fnbamd_dns_parse_resp-got IPv4 DNS reply, req-id=0xac1
[306] fnbamd_dns_parse_resp-req 0xac1: 10.0.4.4
[1150] __fnbamd_ldap_dns_cb-Resolved Azure-DC01:az-bu-dc01.bnmg.net to 10.0.4.4, cur stack size:1
[925] __fnbamd_ldap_get_next_addr-
[1155] __fnbamd_ldap_dns_cb-Connection starts Azure-DC01:az-bu-dc01.bnmg.net, addr 10.0.4.4
[880] __fnbamd_ldap_start_conn-Still connecting 10.0.4.4.
[247] fnbamd_dns_parse_resp-got IPv6 DNS reply, req-id=0x2ac1
[266] fnbamd_dns_parse_resp-req 0xac1: wrong dns format, qr=1, opcode=0, qdc=1, ancount=0
[35] __fnbamd_dns_req_del-DNS req 0xac1 (0xfd4dd70) is removed. Current total: 2
[47] __fnbamd_dns_req_del-DNS maintainer stopped.
[1150] __fnbamd_ldap_dns_cb-Resolved Azure-DC01:az-bu-dc01.bnmg.net to ::, cur stack size:0
[1108] __ldap_connect-tcps_connect(10.0.4.4) is established.
[986] __ldap_rxtx-state 1(StartTLS)
[1083] fnbamd_ldap_send-sending 31 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 1
[986] __ldap_rxtx-state 2(StartTLS resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 38
[1306] fnbamd_ldap_recv-Response len: 40, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:1, type:extended-result
[1023] fnbamd_ldap_parse_response-ret=0
[1053] __ldap_rxtx-Change state to 'Connecting'
[1108] __ldap_connect-tcps_connect(10.0.4.4) is established.
[986] __ldap_rxtx-state 3(Admin Binding)
[363] __ldap_build_bind_req-Binding to 'ldap_vpnadmin'
[1083] fnbamd_ldap_send-sending 51 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 2
[986] __ldap_rxtx-state 4(Admin Bind resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 14
[1306] fnbamd_ldap_recv-Response len: 16, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:2, type:bind
[1023] fnbamd_ldap_parse_response-ret=0
[1053] __ldap_rxtx-Change state to 'DN search'
[986] __ldap_rxtx-state 11(DN search)
[750] fnbamd_ldap_build_dn_search_req-base:'dc=bnmg,dc=net' filter:sAMAccountName=ifacosta
[1083] fnbamd_ldap_send-sending 73 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 3
[986] __ldap_rxtx-state 12(DN search resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 108
[1306] fnbamd_ldap_recv-Response len: 110, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-entry
[1023] fnbamd_ldap_parse_response-ret=0
[1226] __fnbamd_ldap_dn_entry-Get DN 'CN=Iscela Fontes-Acosta,OU=Chula Vista 2,OU=South Bay,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET'
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 72
[1306] fnbamd_ldap_recv-Response len: 74, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 72
[1306] fnbamd_ldap_recv-Response len: 74, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 56
[1306] fnbamd_ldap_recv-Response len: 58, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 72
[1306] fnbamd_ldap_recv-Response len: 74, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 14
[1306] fnbamd_ldap_recv-Response len: 16, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-result
[1023] fnbamd_ldap_parse_response-ret=0
[1053] __ldap_rxtx-Change state to 'User Binding'
[986] __ldap_rxtx-state 5(User Binding)
[596] fnbamd_ldap_build_userbind_req-Trying DN 'CN=Iscela Fontes-Acosta,OU=Chula Vista 2,OU=South Bay,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET'
[363] __ldap_build_bind_req-Binding to 'CN=Iscela Fontes-Acosta,OU=Chula Vista 2,OU=South Bay,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET'
[1083] fnbamd_ldap_send-sending 147 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 4
[986] __ldap_rxtx-state 6(User Bind resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 14
[1306] fnbamd_ldap_recv-Response len: 16, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:4, type:bind
[1023] fnbamd_ldap_parse_response-ret=0
[1053] __ldap_rxtx-Change state to 'Attr query'
[986] __ldap_rxtx-state 7(Attr query)
[649] fnbamd_ldap_build_attr_search_req-Adding attr 'memberOf'
[661] fnbamd_ldap_build_attr_search_req-base:'CN=Iscela Fontes-Acosta,OU=Chula Vista 2,OU=South Bay,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET' filter:cn=*
[1083] fnbamd_ldap_send-sending 171 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 5
[986] __ldap_rxtx-state 8(Attr query resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 920
[1306] fnbamd_ldap_recv-Response len: 922, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:5, type:search-entry
[1023] fnbamd_ldap_parse_response-ret=0
[556] __get_member_of_groups-Get the memberOf groups.
[522] __retrieve_group_values-Get the memberOf groups.
[532] __retrieve_group_values- attr='memberOf', found 10 values
[542] __retrieve_group_values-val[0]='CN=Clinical Staff,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[1]='CN=Clinical Staff and Physicians,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[2]='CN=Chula Vista 2,OU=Chula Vista 2,OU=South Bay,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[3]='CN=SG-Medical Assistants and Front Desk,OU=Security Groups,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[4]='CN=gp_sslvpn,OU=Security Groups,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[5]='CN=FS-Ace-RW,OU=Ace,OU=Executive Square,OU=Corporate,OU=BU,OU=Organizations,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[6]='CN=SG-RedirectedFolders,OU=Security Groups,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[7]='CN=Centricity - Beginning Scheduling,OU=Centricity - Security Groups,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[8]='CN=RDP-Users,CN=Users,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[9]='CN=Chula Vista,OU=Chula Vista 1,OU=South Bay,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET'
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 14
[1306] fnbamd_ldap_recv-Response len: 16, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:5, type:search-result
[1023] fnbamd_ldap_parse_response-ret=0
[1306] __fnbamd_ldap_attr_next-Entering CHKPRIMARYGRP state
[1053] __ldap_rxtx-Change state to 'Primary group query'
[986] __ldap_rxtx-state 13(Primary group query)
[685] fnbamd_ldap_build_primary_grp_search_req-starting primary group check...
[689] fnbamd_ldap_build_primary_grp_search_req-number of sub auths 5
[707] fnbamd_ldap_build_primary_grp_search_req-base:'dc=bnmg,dc=net' filter:(&(objectclass=group)(objectSid=\01\05\00\00\00\00\00\05\15\00\00\00\93\40\b0\c4\54\2c\9d\c4\92\7a\25\74\01\02\00\00))
[1083] fnbamd_ldap_send-sending 118 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 6
[986] __ldap_rxtx-state 14(Primary group query resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 107
[1306] fnbamd_ldap_recv-Response len: 109, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:6, type:search-entry
[1023] fnbamd_ldap_parse_response-ret=0
[472] __get_one_group-group: CN=Domain Users,CN=Users,DC=BNMG,DC=NET
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 72
[1306] fnbamd_ldap_recv-Response len: 74, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:6, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 72
[1306] fnbamd_ldap_recv-Response len: 74, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:6, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 56
[1306] fnbamd_ldap_recv-Response len: 58, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:6, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 72
[1306] fnbamd_ldap_recv-Response len: 74, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:6, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 14
[1306] fnbamd_ldap_recv-Response len: 16, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:6, type:search-result
[1023] fnbamd_ldap_parse_response-ret=0
[1431] __fnbamd_ldap_primary_grp_next-Auth accepted
[1053] __ldap_rxtx-Change state to 'Done'
[986] __ldap_rxtx-state 23(Done)
[1083] fnbamd_ldap_send-sending 7 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 7
[785] __ldap_done-svr 'Azure-DC01'
[755] __ldap_destroy-
[724] __ldap_stop-Conn with 10.0.4.4 destroyed.
[2831] fnbamd_ldap_result-Result for ldap svr az-bu-dc01.bnmg.net(Azure-DC01) is SUCCESS
[401] ldap_copy_grp_list-copied CN=Clinical Staff,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=Clinical Staff and Physicians,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=Chula Vista 2,OU=Chula Vista 2,OU=South Bay,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=SG-Medical Assistants and Front Desk,OU=Security Groups,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=gp_sslvpn,OU=Security Groups,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=FS-Ace-RW,OU=Ace,OU=Executive Square,OU=Corporate,OU=BU,OU=Organizations,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=SG-RedirectedFolders,OU=Security Groups,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=Centricity - Beginning Scheduling,OU=Centricity - Security Groups,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=RDP-Users,CN=Users,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=Chula Vista,OU=Chula Vista 1,OU=South Bay,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=Domain Users,CN=Users,DC=BNMG,DC=NET
[1623] fnbam_user_auth_group_match-req id: 1804971480, server: Azure-DC01, local auth: 0, dn match: 1
[2839] fnbamd_ldap_result-Failed group matching
[209] fnbamd_comm_send_result-Sending result 1 (nid 0) for req 1804971480, len=3271
[808] destroy_auth_session-delete session 1804971480
[755] __ldap_destroy-
[1764] fnbamd_ldap_auth_ctx_free-Freeing 'Azure-DC01' ctx
[1086] fnbamd_ext_idps_destroy-
[2487] handle_req-Rcvd auth_cert req id=1804971481, len=1128, opt=0
[983] __cert_auth_ctx_init-req_id=1804971481, opt=0
[103] __cert_chg_st- 'Init'
[156] fnbamd_cert_load_certs_from_req-2 cert(s) in req.
[669] __cert_init-req_id=1804971481
[718] __cert_build_chain-req_id=1804971481
[273] fnbamd_chain_build-Chain discovery, opt 0x13, cur total 1
[291] fnbamd_chain_build-Following depth 0
[326] fnbamd_chain_build-Extend chain by system trust store. (good: 'CA_Cert_1')
[291] fnbamd_chain_build-Following depth 1
[326] fnbamd_chain_build-Extend chain by system trust store. (good: 'CA_Cert_2')
[291] fnbamd_chain_build-Following depth 2
[305] fnbamd_chain_build-Self-sign detected.
[99] __cert_chg_st- 'Init' -> 'Validation'
[840] __cert_verify-req_id=1804971481
[841] __cert_verify-Chain is complete.
[486] fnbamd_cert_verify-Chain number:3
[500] fnbamd_cert_verify-Following cert chain depth 0
[573] fnbamd_cert_verify-Issuer found: CA_Cert_1 (SSL_DPI opt 1)
[500] fnbamd_cert_verify-Following cert chain depth 1
[573] fnbamd_cert_verify-Issuer found: CA_Cert_2 (SSL_DPI opt 1)
[500] fnbamd_cert_verify-Following cert chain depth 2
[657] fnbamd_cert_check_group_list-group list is empty, match any!
[191] __get_default_ocsp_ctx-def_ocsp_ctx=(nil), no_ocsp_query=0, ocsp_enabled=0
[876] __cert_verify_do_next-req_id=1804971481
[99] __cert_chg_st- 'Validation' -> 'Done'
[921] __cert_done-req_id=1804971481
[1654] fnbamd_auth_session_done-Session done, id=1804971481
[966] __fnbamd_cert_auth_run-Exit, req_id=1804971481
[1691] create_auth_cert_session-fnbamd_cert_auth_init returns 0, id=1804971481
[1610] auth_cert_success-id=1804971481
[1068] fnbamd_cert_auth_copy_cert_status-req_id=1804971481
[1107] fnbamd_cert_auth_copy_cert_status-Leaf cert status is unchecked.
[1195] fnbamd_cert_auth_copy_cert_status-Cert st 2c0, req_id=1804971481
[209] fnbamd_comm_send_result-Sending result 0 (nid 672) for req 1804971481, len=2536
[1555] destroy_auth_cert_session-id=1804971481
[1041] fnbamd_cert_auth_uninit-req_id=1804971481
[1909] handle_req-Rcvd auth req 1804971482 for clesniak in  opt=00200421 prot=11
[489] __compose_group_list_from_req-Group 'SG-VPN-AlwaysOn', type 1
[489] __compose_group_list_from_req-Group 'SG-VPN-OnDemand', type 1
[616] fnbamd_pop3_start-clesniak
[378] radius_start-Didn't find radius servers (0)
[764] auth_tac_plus_start-Didn't find tac_plus servers (0)
[1009] __fnbamd_cfg_get_ldap_list_by_group-
[1067] __fnbamd_cfg_get_ldap_list_by_group-Loaded LDAP server 'Azure-DC01' for usergroup 'SG-VPN-AlwaysOn' (2)
[1836] fnbamd_ldap_auth_ctx_push-'Azure-DC01' is already in the ldap list.
[1067] __fnbamd_cfg_get_ldap_list_by_group-Loaded LDAP server 'Azure-DC01' for usergroup 'SG-VPN-OnDemand' (4)
[1117] fnbamd_cfg_get_ldap_list-Total ldap servers to try: 1
[1718] fnbamd_ldap_init-search filter is: sAMAccountName=clesniak
[1728] fnbamd_ldap_init-search base is: dc=bnmg,dc=net
[115] fnbamd_dns_resolv_ex-DNS req ipv4 0xac2 'az-bu-dc01.bnmg.net'
[125] fnbamd_dns_resolv_ex-DNS req ipv6 0x2ac2 'az-bu-dc01.bnmg.net'
[137] fnbamd_dns_resolv_ex-DNS maintainer started.
[480] fnbamd_cfg_get_ext_idp_list-
[454] __fnbamd_cfg_get_ext_idp_list_by_group-
[460] __fnbamd_cfg_get_ext_idp_list_by_group-Group 'SG-VPN-AlwaysOn'
[460] __fnbamd_cfg_get_ext_idp_list_by_group-Group 'SG-VPN-OnDemand'
[490] fnbamd_cfg_get_ext_idp_list-Total external identity provider servers to try: 0
[652] create_auth_session-Total 1 server(s) to try
[1950] handle_req-r=4
[247] fnbamd_dns_parse_resp-got IPv4 DNS reply, req-id=0xac2
[306] fnbamd_dns_parse_resp-req 0xac2: 10.0.4.4
[1150] __fnbamd_ldap_dns_cb-Resolved Azure-DC01:az-bu-dc01.bnmg.net to 10.0.4.4, cur stack size:1
[925] __fnbamd_ldap_get_next_addr-
[1155] __fnbamd_ldap_dns_cb-Connection starts Azure-DC01:az-bu-dc01.bnmg.net, addr 10.0.4.4
[880] __fnbamd_ldap_start_conn-Still connecting 10.0.4.4.
[1108] __ldap_connect-tcps_connect(10.0.4.4) is established.
[247] fnbamd_dns_parse_resp-got IPv6 DNS reply, req-id=0x2ac2
[266] fnbamd_dns_parse_resp-req 0xac2: wrong dns format, qr=1, opcode=0, qdc=1, ancount=0
[35] __fnbamd_dns_req_del-DNS req 0xac2 (0xfd4dd70) is removed. Current total: 2
[47] __fnbamd_dns_req_del-DNS maintainer stopped.
[1150] __fnbamd_ldap_dns_cb-Resolved Azure-DC01:az-bu-dc01.bnmg.net to ::, cur stack size:0
[986] __ldap_rxtx-state 1(StartTLS)
[1083] fnbamd_ldap_send-sending 31 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 1
[986] __ldap_rxtx-state 2(StartTLS resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 38
[1306] fnbamd_ldap_recv-Response len: 40, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:1, type:extended-result
[1023] fnbamd_ldap_parse_response-ret=0
[1053] __ldap_rxtx-Change state to 'Connecting'
[1108] __ldap_connect-tcps_connect(10.0.4.4) is established.
[986] __ldap_rxtx-state 3(Admin Binding)
[363] __ldap_build_bind_req-Binding to 'ldap_vpnadmin'
[1083] fnbamd_ldap_send-sending 51 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 2
[986] __ldap_rxtx-state 4(Admin Bind resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 14
[1306] fnbamd_ldap_recv-Response len: 16, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:2, type:bind
[1023] fnbamd_ldap_parse_response-ret=0
[1053] __ldap_rxtx-Change state to 'DN search'
[986] __ldap_rxtx-state 11(DN search)
[750] fnbamd_ldap_build_dn_search_req-base:'dc=bnmg,dc=net' filter:sAMAccountName=clesniak
[1083] fnbamd_ldap_send-sending 73 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 3
[986] __ldap_rxtx-state 12(DN search resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 106
[1306] fnbamd_ldap_recv-Response len: 108, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-entry
[1023] fnbamd_ldap_parse_response-ret=0
[1226] __fnbamd_ldap_dn_entry-Get DN 'CN=Christina Lesniak,OU=Executive Square,OU=Corporate,OU=BU,OU=Organizations,DC=BNMG,DC=NET'
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 72
[1306] fnbamd_ldap_recv-Response len: 74, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 72
[1306] fnbamd_ldap_recv-Response len: 74, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 56
[1306] fnbamd_ldap_recv-Response len: 58, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 72
[1306] fnbamd_ldap_recv-Response len: 74, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 14
[1306] fnbamd_ldap_recv-Response len: 16, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-result
[1023] fnbamd_ldap_parse_response-ret=0
[1053] __ldap_rxtx-Change state to 'User Binding'
[986] __ldap_rxtx-state 5(User Binding)
[596] fnbamd_ldap_build_userbind_req-Trying DN 'CN=Christina Lesniak,OU=Executive Square,OU=Corporate,OU=BU,OU=Organizations,DC=BNMG,DC=NET'
[363] __ldap_build_bind_req-Binding to 'CN=Christina Lesniak,OU=Executive Square,OU=Corporate,OU=BU,OU=Organizations,DC=BNMG,DC=NET'
[1083] fnbamd_ldap_send-sending 144 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 4
[986] __ldap_rxtx-state 6(User Bind resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 14
[1306] fnbamd_ldap_recv-Response len: 16, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:4, type:bind
[1023] fnbamd_ldap_parse_response-ret=0
[1053] __ldap_rxtx-Change state to 'Attr query'
[986] __ldap_rxtx-state 7(Attr query)
[649] fnbamd_ldap_build_attr_search_req-Adding attr 'memberOf'
[661] fnbamd_ldap_build_attr_search_req-base:'CN=Christina Lesniak,OU=Executive Square,OU=Corporate,OU=BU,OU=Organizations,DC=BNMG,DC=NET' filter:cn=*
[1083] fnbamd_ldap_send-sending 169 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 5
[986] __ldap_rxtx-state 8(Attr query resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 750
[1306] fnbamd_ldap_recv-Response len: 752, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:5, type:search-entry
[1023] fnbamd_ldap_parse_response-ret=0
[556] __get_member_of_groups-Get the memberOf groups.
[522] __retrieve_group_values-Get the memberOf groups.
[532] __retrieve_group_values- attr='memberOf', found 9 values
[542] __retrieve_group_values-val[0]='CN=SG-VPN-AlwaysOn,OU=Security Groups,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[1]='CN=FS-SharePoint/OneDrive External Sharing,OU=Distribution Groups,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[2]='CN=Camino Renal Care Email Address,OU=Security Groups,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[3]='CN=FS-Shareholder-RW,OU=Security Groups,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[4]='CN=gp_sslvpn,OU=Security Groups,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[5]='CN=Board & Pod,OU=Security Groups,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[6]='CN=FS-Confidential-Executive-Drive,OU=Security Groups,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[7]='CN=FS-Policies-and-Procedures-RW,OU=Security Groups,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[8]='CN=RDP-Users,CN=Users,DC=BNMG,DC=NET'
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 14
[1306] fnbamd_ldap_recv-Response len: 16, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:5, type:search-result
[1023] fnbamd_ldap_parse_response-ret=0
[1306] __fnbamd_ldap_attr_next-Entering CHKPRIMARYGRP state
[1053] __ldap_rxtx-Change state to 'Primary group query'
[986] __ldap_rxtx-state 13(Primary group query)
[685] fnbamd_ldap_build_primary_grp_search_req-starting primary group check...
[689] fnbamd_ldap_build_primary_grp_search_req-number of sub auths 5
[707] fnbamd_ldap_build_primary_grp_search_req-base:'dc=bnmg,dc=net' filter:(&(objectclass=group)(objectSid=\01\05\00\00\00\00\00\05\15\00\00\00\93\40\b0\c4\54\2c\9d\c4\92\7a\25\74\01\02\00\00))
[1083] fnbamd_ldap_send-sending 118 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 6
[986] __ldap_rxtx-state 14(Primary group query resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 107
[1306] fnbamd_ldap_recv-Response len: 109, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:6, type:search-entry
[1023] fnbamd_ldap_parse_response-ret=0
[472] __get_one_group-group: CN=Domain Users,CN=Users,DC=BNMG,DC=NET
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 72
[1306] fnbamd_ldap_recv-Response len: 74, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:6, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 72
[1306] fnbamd_ldap_recv-Response len: 74, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:6, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 56
[1306] fnbamd_ldap_recv-Response len: 58, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:6, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 72
[1306] fnbamd_ldap_recv-Response len: 74, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:6, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 14
[1306] fnbamd_ldap_recv-Response len: 16, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:6, type:search-result
[1023] fnbamd_ldap_parse_response-ret=0
[1431] __fnbamd_ldap_primary_grp_next-Auth accepted
[1053] __ldap_rxtx-Change state to 'Done'
[986] __ldap_rxtx-state 23(Done)
[1083] fnbamd_ldap_send-sending 7 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 7
[785] __ldap_done-svr 'Azure-DC01'
[755] __ldap_destroy-
[724] __ldap_stop-Conn with 10.0.4.4 destroyed.
[2831] fnbamd_ldap_result-Result for ldap svr az-bu-dc01.bnmg.net(Azure-DC01) is SUCCESS
[401] ldap_copy_grp_list-copied CN=SG-VPN-AlwaysOn,OU=Security Groups,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=FS-SharePoint/OneDrive External Sharing,OU=Distribution Groups,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=Camino Renal Care Email Address,OU=Security Groups,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=FS-Shareholder-RW,OU=Security Groups,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=gp_sslvpn,OU=Security Groups,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=Board & Pod,OU=Security Groups,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=FS-Confidential-Executive-Drive,OU=Security Groups,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=FS-Policies-and-Procedures-RW,OU=Security Groups,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=RDP-Users,CN=Users,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=Domain Users,CN=Users,DC=BNMG,DC=NET
[1623] fnbam_user_auth_group_match-req id: 1804971482, server: Azure-DC01, local auth: 0, dn match: 1
[1592] __group_match-Group 'SG-VPN-AlwaysOn' passed group matching
[1595] __group_match-Add matched group 'SG-VPN-AlwaysOn'(2)
[2843] fnbamd_ldap_result-Passed group matching
[209] fnbamd_comm_send_result-Sending result 0 (nid 0) for req 1804971482, len=3108
[808] destroy_auth_session-delete session 1804971482
[755] __ldap_destroy-
[1764] fnbamd_ldap_auth_ctx_free-Freeing 'Azure-DC01' ctx
[1086] fnbamd_ext_idps_destroy-
[2487] handle_req-Rcvd auth_cert req id=1804971483, len=1128, opt=0
[983] __cert_auth_ctx_init-req_id=1804971483, opt=0
[103] __cert_chg_st- 'Init'
[156] fnbamd_cert_load_certs_from_req-2 cert(s) in req.
[669] __cert_init-req_id=1804971483
[718] __cert_build_chain-req_id=1804971483
[273] fnbamd_chain_build-Chain discovery, opt 0x13, cur total 1
[291] fnbamd_chain_build-Following depth 0
[326] fnbamd_chain_build-Extend chain by system trust store. (good: 'CA_Cert_1')
[291] fnbamd_chain_build-Following depth 1
[326] fnbamd_chain_build-Extend chain by system trust store. (good: 'CA_Cert_2')
[291] fnbamd_chain_build-Following depth 2
[305] fnbamd_chain_build-Self-sign detected.
[99] __cert_chg_st- 'Init' -> 'Validation'
[840] __cert_verify-req_id=1804971483
[841] __cert_verify-Chain is complete.
[486] fnbamd_cert_verify-Chain number:3
[500] fnbamd_cert_verify-Following cert chain depth 0
[573] fnbamd_cert_verify-Issuer found: CA_Cert_1 (SSL_DPI opt 1)
[500] fnbamd_cert_verify-Following cert chain depth 1
[573] fnbamd_cert_verify-Issuer found: CA_Cert_2 (SSL_DPI opt 1)
[500] fnbamd_cert_verify-Following cert chain depth 2
[657] fnbamd_cert_check_group_list-group list is empty, match any!
[191] __get_default_ocsp_ctx-def_ocsp_ctx=(nil), no_ocsp_query=0, ocsp_enabled=0
[876] __cert_verify_do_next-req_id=1804971483
[99] __cert_chg_st- 'Validation' -> 'Done'
[921] __cert_done-req_id=1804971483
[1654] fnbamd_auth_session_done-Session done, id=1804971483
[966] __fnbamd_cert_auth_run-Exit, req_id=1804971483
[1691] create_auth_cert_session-fnbamd_cert_auth_init returns 0, id=1804971483
[1610] auth_cert_success-id=1804971483
[1068] fnbamd_cert_auth_copy_cert_status-req_id=1804971483
[1107] fnbamd_cert_auth_copy_cert_status-Leaf cert status is unchecked.
[1195] fnbamd_cert_auth_copy_cert_status-Cert st 2c0, req_id=1804971483
[209] fnbamd_comm_send_result-Sending result 0 (nid 672) for req 1804971483, len=2536
[1555] destroy_auth_cert_session-id=1804971483
[1041] fnbamd_cert_auth_uninit-req_id=1804971483
[1909] handle_req-Rcvd auth req 1804971484 for ifacosta in  opt=00200421 prot=11
[489] __compose_group_list_from_req-Group 'SG-VPN-AlwaysOn', type 1
[489] __compose_group_list_from_req-Group 'SG-VPN-OnDemand', type 1
[616] fnbamd_pop3_start-ifacosta
[378] radius_start-Didn't find radius servers (0)
[764] auth_tac_plus_start-Didn't find tac_plus servers (0)
[1009] __fnbamd_cfg_get_ldap_list_by_group-
[1067] __fnbamd_cfg_get_ldap_list_by_group-Loaded LDAP server 'Azure-DC01' for usergroup 'SG-VPN-AlwaysOn' (2)
[1836] fnbamd_ldap_auth_ctx_push-'Azure-DC01' is already in the ldap list.
[1067] __fnbamd_cfg_get_ldap_list_by_group-Loaded LDAP server 'Azure-DC01' for usergroup 'SG-VPN-OnDemand' (4)
[1117] fnbamd_cfg_get_ldap_list-Total ldap servers to try: 1
[1718] fnbamd_ldap_init-search filter is: sAMAccountName=ifacosta
[1728] fnbamd_ldap_init-search base is: dc=bnmg,dc=net
[115] fnbamd_dns_resolv_ex-DNS req ipv4 0xac3 'az-bu-dc01.bnmg.net'
[125] fnbamd_dns_resolv_ex-DNS req ipv6 0x2ac3 'az-bu-dc01.bnmg.net'
[137] fnbamd_dns_resolv_ex-DNS maintainer started.
[480] fnbamd_cfg_get_ext_idp_list-
[454] __fnbamd_cfg_get_ext_idp_list_by_group-
[460] __fnbamd_cfg_get_ext_idp_list_by_group-Group 'SG-VPN-AlwaysOn'
[460] __fnbamd_cfg_get_ext_idp_list_by_group-Group 'SG-VPN-OnDemand'
[490] fnbamd_cfg_get_ext_idp_list-Total external identity provider servers to try: 0
[652] create_auth_session-Total 1 server(s) to try
[1950] handle_req-r=4
[247] fnbamd_dns_parse_resp-got IPv4 DNS reply, req-id=0xac3
[306] fnbamd_dns_parse_resp-req 0xac3: 10.0.4.4
[1150] __fnbamd_ldap_dns_cb-Resolved Azure-DC01:az-bu-dc01.bnmg.net to 10.0.4.4, cur stack size:1
[925] __fnbamd_ldap_get_next_addr-
[1155] __fnbamd_ldap_dns_cb-Connection starts Azure-DC01:az-bu-dc01.bnmg.net, addr 10.0.4.4
[880] __fnbamd_ldap_start_conn-Still connecting 10.0.4.4.
[247] fnbamd_dns_parse_resp-got IPv6 DNS reply, req-id=0x2ac3
[266] fnbamd_dns_parse_resp-req 0xac3: wrong dns format, qr=1, opcode=0, qdc=1, ancount=0
[35] __fnbamd_dns_req_del-DNS req 0xac3 (0xfd4dd70) is removed. Current total: 2
[47] __fnbamd_dns_req_del-DNS maintainer stopped.
[1150] __fnbamd_ldap_dns_cb-Resolved Azure-DC01:az-bu-dc01.bnmg.net to ::, cur stack size:0
[1108] __ldap_connect-tcps_connect(10.0.4.4) is established.
[986] __ldap_rxtx-state 1(StartTLS)
[1083] fnbamd_ldap_send-sending 31 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 1
[986] __ldap_rxtx-state 2(StartTLS resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 38
[1306] fnbamd_ldap_recv-Response len: 40, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:1, type:extended-result
[1023] fnbamd_ldap_parse_response-ret=0
[1053] __ldap_rxtx-Change state to 'Connecting'
[1108] __ldap_connect-tcps_connect(10.0.4.4) is established.
[986] __ldap_rxtx-state 3(Admin Binding)
[363] __ldap_build_bind_req-Binding to 'ldap_vpnadmin'
[1083] fnbamd_ldap_send-sending 51 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 2
[986] __ldap_rxtx-state 4(Admin Bind resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 14
[1306] fnbamd_ldap_recv-Response len: 16, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:2, type:bind
[1023] fnbamd_ldap_parse_response-ret=0
[1053] __ldap_rxtx-Change state to 'DN search'
[986] __ldap_rxtx-state 11(DN search)
[750] fnbamd_ldap_build_dn_search_req-base:'dc=bnmg,dc=net' filter:sAMAccountName=ifacosta
[1083] fnbamd_ldap_send-sending 73 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 3
[986] __ldap_rxtx-state 12(DN search resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 108
[1306] fnbamd_ldap_recv-Response len: 110, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-entry
[1023] fnbamd_ldap_parse_response-ret=0
[1226] __fnbamd_ldap_dn_entry-Get DN 'CN=Iscela Fontes-Acosta,OU=Chula Vista 2,OU=South Bay,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET'
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 72
[1306] fnbamd_ldap_recv-Response len: 74, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 72
[1306] fnbamd_ldap_recv-Response len: 74, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 56
[1306] fnbamd_ldap_recv-Response len: 58, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 72
[1306] fnbamd_ldap_recv-Response len: 74, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 14
[1306] fnbamd_ldap_recv-Response len: 16, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:3, type:search-result
[1023] fnbamd_ldap_parse_response-ret=0
[1053] __ldap_rxtx-Change state to 'User Binding'
[986] __ldap_rxtx-state 5(User Binding)
[596] fnbamd_ldap_build_userbind_req-Trying DN 'CN=Iscela Fontes-Acosta,OU=Chula Vista 2,OU=South Bay,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET'
[363] __ldap_build_bind_req-Binding to 'CN=Iscela Fontes-Acosta,OU=Chula Vista 2,OU=South Bay,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET'
[1083] fnbamd_ldap_send-sending 147 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 4
[986] __ldap_rxtx-state 6(User Bind resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 14
[1306] fnbamd_ldap_recv-Response len: 16, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:4, type:bind
[1023] fnbamd_ldap_parse_response-ret=0
[1053] __ldap_rxtx-Change state to 'Attr query'
[986] __ldap_rxtx-state 7(Attr query)
[649] fnbamd_ldap_build_attr_search_req-Adding attr 'memberOf'
[661] fnbamd_ldap_build_attr_search_req-base:'CN=Iscela Fontes-Acosta,OU=Chula Vista 2,OU=South Bay,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET' filter:cn=*
[1083] fnbamd_ldap_send-sending 171 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 5
[986] __ldap_rxtx-state 8(Attr query resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 920
[1306] fnbamd_ldap_recv-Response len: 922, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:5, type:search-entry
[1023] fnbamd_ldap_parse_response-ret=0
[556] __get_member_of_groups-Get the memberOf groups.
[522] __retrieve_group_values-Get the memberOf groups.
[532] __retrieve_group_values- attr='memberOf', found 10 values
[542] __retrieve_group_values-val[0]='CN=Clinical Staff,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[1]='CN=Clinical Staff and Physicians,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[2]='CN=Chula Vista 2,OU=Chula Vista 2,OU=South Bay,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[3]='CN=SG-Medical Assistants and Front Desk,OU=Security Groups,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[4]='CN=gp_sslvpn,OU=Security Groups,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[5]='CN=FS-Ace-RW,OU=Ace,OU=Executive Square,OU=Corporate,OU=BU,OU=Organizations,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[6]='CN=SG-RedirectedFolders,OU=Security Groups,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[7]='CN=Centricity - Beginning Scheduling,OU=Centricity - Security Groups,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[8]='CN=RDP-Users,CN=Users,DC=BNMG,DC=NET'
[542] __retrieve_group_values-val[9]='CN=Chula Vista,OU=Chula Vista 1,OU=South Bay,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET'
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 14
[1306] fnbamd_ldap_recv-Response len: 16, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:5, type:search-result
[1023] fnbamd_ldap_parse_response-ret=0
[1306] __fnbamd_ldap_attr_next-Entering CHKPRIMARYGRP state
[1053] __ldap_rxtx-Change state to 'Primary group query'
[986] __ldap_rxtx-state 13(Primary group query)
[685] fnbamd_ldap_build_primary_grp_search_req-starting primary group check...
[689] fnbamd_ldap_build_primary_grp_search_req-number of sub auths 5
[707] fnbamd_ldap_build_primary_grp_search_req-base:'dc=bnmg,dc=net' filter:(&(objectclass=group)(objectSid=\01\05\00\00\00\00\00\05\15\00\00\00\93\40\b0\c4\54\2c\9d\c4\92\7a\25\74\01\02\00\00))
[1083] fnbamd_ldap_send-sending 118 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 6
[986] __ldap_rxtx-state 14(Primary group query resp)
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 107
[1306] fnbamd_ldap_recv-Response len: 109, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:6, type:search-entry
[1023] fnbamd_ldap_parse_response-ret=0
[472] __get_one_group-group: CN=Domain Users,CN=Users,DC=BNMG,DC=NET
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 72
[1306] fnbamd_ldap_recv-Response len: 74, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:6, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 72
[1306] fnbamd_ldap_recv-Response len: 74, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:6, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 56
[1306] fnbamd_ldap_recv-Response len: 58, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:6, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 72
[1306] fnbamd_ldap_recv-Response len: 74, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:6, type:search-reference
[1023] fnbamd_ldap_parse_response-ret=0
[1127] __fnbamd_ldap_read-Read 8
[1233] fnbamd_ldap_recv-Leftover 2
[1127] __fnbamd_ldap_read-Read 14
[1306] fnbamd_ldap_recv-Response len: 16, svr: 10.0.4.4
[987] fnbamd_ldap_parse_response-Got one MESSAGE. ID:6, type:search-result
[1023] fnbamd_ldap_parse_response-ret=0
[1431] __fnbamd_ldap_primary_grp_next-Auth accepted
[1053] __ldap_rxtx-Change state to 'Done'
[986] __ldap_rxtx-state 23(Done)
[1083] fnbamd_ldap_send-sending 7 bytes to 10.0.4.4
[1096] fnbamd_ldap_send-Request is sent. ID 7
[785] __ldap_done-svr 'Azure-DC01'
[755] __ldap_destroy-
[724] __ldap_stop-Conn with 10.0.4.4 destroyed.
[2831] fnbamd_ldap_result-Result for ldap svr az-bu-dc01.bnmg.net(Azure-DC01) is SUCCESS
[401] ldap_copy_grp_list-copied CN=Clinical Staff,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=Clinical Staff and Physicians,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=Chula Vista 2,OU=Chula Vista 2,OU=South Bay,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=SG-Medical Assistants and Front Desk,OU=Security Groups,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=gp_sslvpn,OU=Security Groups,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=FS-Ace-RW,OU=Ace,OU=Executive Square,OU=Corporate,OU=BU,OU=Organizations,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=SG-RedirectedFolders,OU=Security Groups,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=Centricity - Beginning Scheduling,OU=Centricity - Security Groups,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=RDP-Users,CN=Users,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=Chula Vista,OU=Chula Vista 1,OU=South Bay,OU=BNMG,OU=Organizations,DC=BNMG,DC=NET
[401] ldap_copy_grp_list-copied CN=Domain Users,CN=Users,DC=BNMG,DC=NET
[1623] fnbam_user_auth_group_match-req id: 1804971484, server: Azure-DC01, local auth: 0, dn match: 1
[2839] fnbamd_ldap_result-Failed group matching
[209] fnbamd_comm_send_result-Sending result 1 (nid 0) for req 1804971484, len=3271
[808] destroy_auth_session-delete session 1804971484
[755] __ldap_destroy-
[1764] fnbamd_ldap_auth_ctx_free-Freeing 'Azure-DC01' ctx
[1086] fnbamd_ext_idps_destroy-
2024-04-03 09:49:25 [2380:root:12681]SSL state:warning close notify (45.135.232.100)
2024-04-03 09:49:25 [2380:root:12681]sslConnGotoNextState:317 error (last state: 1, closeOp: 0)
2024-04-03 09:49:25 [2380:root:12681]Destroy sconn 0x7f07e0291000, connSize=49. (root)
2024-04-03 09:49:25 [2380:root:12681]SSL state:warning close notify (45.135.232.100)
2024-04-03 09:49:25 [2380:root:12682]SSL state:warning close notify (45.135.232.100)
2024-04-03 09:49:25 [2380:root:12682]sslConnGotoNextState:317 error (last state: 1, closeOp: 0)
2024-04-03 09:49:25 [2380:root:12682]Destroy sconn 0x7f07e0336800, connSize=48. (root)
2024-04-03 09:49:25 [2380:root:12682]SSL state:warning close notify (45.135.232.100)
2024-04-03 09:49:26 [2380:root:12687]allocSSLConn:310 sconn 0x7f07e0291000 (0:root)
2024-04-03 09:49:26 [2380:root:12688]allocSSLConn:310 sconn 0x7f07e0336800 (0:root)
2024-04-03 09:49:27 [2380:root:12685]SSL state:TLSv1.3 early data (45.140.17.13)
2024-04-03 09:49:27 [2380:root:12685]SSL state:SSLv3/TLS read client certificate (45.140.17.13)
2024-04-03 09:49:27 [2380:root:12685]SSL state:SSLv3/TLS read finished (45.140.17.13)
2024-04-03 09:49:27 [2380:root:12685]SSL state:SSLv3/TLS write session ticket (45.140.17.13)
2024-04-03 09:49:27 [2380:root:12685]SSL state:SSLv3/TLS write session ticket (45.140.17.13)
2024-04-03 09:49:27 [2380:root:12685]SSL established: TLSv1.3 TLS_AES_256_GCM_SHA384
2024-04-03 09:49:27 [2380:root:12685]No client certificate
2024-04-03 09:49:27 [2380:root:12686]SSL state:TLSv1.3 early data (45.140.17.13)
2024-04-03 09:49:27 [2380:root:12686]SSL state:SSLv3/TLS read client certificate (45.140.17.13)
2024-04-03 09:49:27 [2380:root:12686]SSL state:SSLv3/TLS read finished (45.140.17.13)
2024-04-03 09:49:27 [2380:root:12686]SSL state:SSLv3/TLS write session ticket (45.140.17.13)
2024-04-03 09:49:27 [2380:root:12686]SSL state:SSLv3/TLS write session ticket (45.140.17.13)
2024-04-03 09:49:27 [2380:root:12686]SSL established: TLSv1.3 TLS_AES_256_GCM_SHA384
2024-04-03 09:49:27 [2380:root:12686]No client certificate
2024-04-03 09:49:27 [2380:root:12685]req: /remote/login
2024-04-03 09:49:27 [2380:root:12685]rmt_web_auth_info_parser_common:524 no session id in auth info
2024-04-03 09:49:27 [2380:root:12685]rmt_web_get_access_cache:873 invalid cache, ret=4103
2024-04-03 09:49:27 [2380:root:12685]User Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36 Edg/115.0.1901.203
2024-04-03 09:49:27 [2380:root:12685]sslConnGotoNextState:317 error (last state: 1, closeOp: 0)
2024-04-03 09:49:27 [2380:root:12685]Destroy sconn 0x7f07e0355000, connSize=49. (root)
2024-04-03 09:49:27 [2380:root:12685]SSL state:warning close notify (45.140.17.13)
2024-04-03 09:49:27 [2380:root:12686]req: /remote/login
2024-04-03 09:49:27 [2380:root:12686]rmt_web_auth_info_parser_common:524 no session id in auth info
2024-04-03 09:49:27 [2380:root:12686]rmt_web_get_access_cache:873 invalid cache, ret=4103
2024-04-03 09:49:27 [2380:root:12686]User Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36 Edg/115.0.1901.203
2024-04-03 09:49:27 [2380:root:12686]sslConnGotoNextState:317 error (last state: 1, closeOp: 0)
2024-04-03 09:49:27 [2380:root:12686]Destroy sconn 0x7f07e039a800, connSize=48. (root)
2024-04-03 09:49:27 [2380:root:12686]SSL state:warning close notify (45.140.17.13)
2024-04-03 09:49:27 [2380:root:12687]SSL state:before SSL initialization (45.135.232.100)
2024-04-03 09:49:27 [2380:root:12687]SSL state:before SSL initialization (45.135.232.100)
2024-04-03 09:49:27 [2380:root:12687]got SNI server name: dialup.balboaunited.org realm (null)
2024-04-03 09:49:27 [2380:root:12687]client cert requirement: yes
2024-04-03 09:49:27 [2380:root:12687]SSL state:SSLv3/TLS read client hello (45.135.232.100)
2024-04-03 09:49:27 [2380:root:12687]SSL state:SSLv3/TLS write server hello (45.135.232.100)
2024-04-03 09:49:27 [2380:root:12687]SSL state:SSLv3/TLS write change cipher spec (45.135.232.100)
2024-04-03 09:49:27 [2380:root:12687]SSL state:TLSv1.3 early data (45.135.232.100)
2024-04-03 09:49:27 [2380:root:12687]SSL state:TLSv1.3 early data:(null)(45.135.232.100)
2024-04-03 09:49:27 [2380:root:12688]SSL state:before SSL initialization (45.135.232.100)
2024-04-03 09:49:27 [2380:root:12688]SSL state:before SSL initialization (45.135.232.100)
2024-04-03 09:49:27 [2380:root:12688]got SNI server name: sslvpn.balboaunited.org realm (null)
2024-04-03 09:49:27 [2380:root:12688]client cert requirement: yes
2024-04-03 09:49:27 [2380:root:12688]SSL state:SSLv3/TLS read client hello (45.135.232.100)
2024-04-03 09:49:27 [2380:root:12688]SSL state:SSLv3/TLS write server hello (45.135.232.100)
2024-04-03 09:49:27 [2380:root:12688]SSL state:SSLv3/TLS write change cipher spec (45.135.232.100)
2024-04-03 09:49:27 [2380:root:12688]SSL state:TLSv1.3 early data (45.135.232.100)
2024-04-03 09:49:27 [2380:root:12688]SSL state:TLSv1.3 early data:(null)(45.135.232.100)
2024-04-03 09:49:29 [2380:root:12687]SSL state:TLSv1.3 early data (45.135.232.100)
2024-04-03 09:49:29 [2380:root:12687]got SNI server name: dialup.balboaunited.org realm (null)
2024-04-03 09:49:29 [2380:root:12687]client cert requirement: yes
2024-04-03 09:49:29 [2380:root:12687]SSL state:SSLv3/TLS read client hello (45.135.232.100)
2024-04-03 09:49:29 [2380:root:12687]SSL state:SSLv3/TLS write server hello (45.135.232.100)
2024-04-03 09:49:29 [2380:root:12687]SSL state:TLSv1.3 write encrypted extensions (45.135.232.100)
2024-04-03 09:49:29 [2380:root:12687]SSL state:SSLv3/TLS write finished (45.135.232.100)
2024-04-03 09:49:29 [2380:root:12687]SSL state:TLSv1.3 early data (45.135.232.100)
2024-04-03 09:49:29 [2380:root:12687]SSL state:TLSv1.3 early data:(null)(45.135.232.100)
2024-04-03 09:49:29 [2380:root:12688]SSL state:TLSv1.3 early data (45.135.232.100)
2024-04-03 09:49:29 [2380:root:12688]got SNI server name: sslvpn.balboaunited.org realm (null)
2024-04-03 09:49:29 [2380:root:12688]client cert requirement: yes
2024-04-03 09:49:29 [2380:root:12688]SSL state:SSLv3/TLS read client hello (45.135.232.100)
2024-04-03 09:49:29 [2380:root:12688]SSL state:SSLv3/TLS write server hello (45.135.232.100)
2024-04-03 09:49:29 [2380:root:12688]SSL state:TLSv1.3 write encrypted extensions (45.135.232.100)
2024-04-03 09:49:29 [2380:root:12688]SSL state:SSLv3/TLS write finished (45.135.232.100)
2024-04-03 09:49:29 [2380:root:12688]SSL state:TLSv1.3 early data (45.135.232.100)
2024-04-03 09:49:29 [2380:root:12688]SSL state:TLSv1.3 early data:(null)(45.135.232.100)
2024-04-03 09:49:30 [2380:root:12689]allocSSLConn:310 sconn 0x7f07e0355000 (0:root)
2024-04-03 09:49:30 [2380:root:1268a]allocSSLConn:310 sconn 0x7f07e039a800 (0:root)
2024-04-03 09:49:31 [2380:root:12687]SSL state:TLSv1.3 early data (45.135.232.100)
2024-04-03 09:49:31 [2380:root:12687]SSL state:SSLv3/TLS read finished (45.135.232.100)
2024-04-03 09:49:31 [2380:root:12687]SSL state:SSLv3/TLS write session ticket (45.135.232.100)
2024-04-03 09:49:31 [2380:root:12687]SSL established: TLSv1.3 TLS_AES_256_GCM_SHA384
2024-04-03 09:49:31 [2380:root:12687]No client certificate
2024-04-03 09:49:31 [2380:root:12687]req: /login
2024-04-03 09:49:31 [2380:root:12687]Transfer-Encoding n/a
2024-04-03 09:49:31 [2380:root:12687]Content-Length n/a
2024-04-03 09:49:31 [2380:root:12687]def: (nil) /login
2024-04-03 09:49:31 [2380:root:12688]SSL state:TLSv1.3 early data (45.135.232.100)
2024-04-03 09:49:31 [2380:root:12688]SSL state:SSLv3/TLS read finished (45.135.232.100)
2024-04-03 09:49:31 [2380:root:12688]SSL state:SSLv3/TLS write session ticket (45.135.232.100)
2024-04-03 09:49:31 [2380:root:12688]SSL established: TLSv1.3 TLS_AES_256_GCM_SHA384
2024-04-03 09:49:31 [2380:root:12688]No client certificate
2024-04-03 09:49:31 [2380:root:12688]req: /login
2024-04-03 09:49:31 [2380:root:12688]Transfer-Encoding n/a
2024-04-03 09:49:31 [2380:root:12688]Content-Length n/a
2024-04-03 09:49:31 [2380:root:12688]def: (nil) /login
2024-04-03 09:49:31 [2380:root:12689]SSL state:before SSL initialization (45.140.17.13)
2024-04-03 09:49:31 [2380:root:12689]SSL state:before SSL initialization (45.140.17.13)
2024-04-03 09:49:31 [2380:root:12689]got SNI server name: sslvpn.balboaunited.org realm (null)
2024-04-03 09:49:31 [2380:root:12689]client cert requirement: yes
2024-04-03 09:49:31 [2380:root:12689]SSL state:SSLv3/TLS read client hello (45.140.17.13)
2024-04-03 09:49:31 [2380:root:12689]SSL state:SSLv3/TLS write server hello (45.140.17.13)
2024-04-03 09:49:31 [2380:root:12689]SSL state:SSLv3/TLS write change cipher spec (45.140.17.13)
2024-04-03 09:49:31 [2380:root:12689]SSL state:TLSv1.3 early data (45.140.17.13)
2024-04-03 09:49:31 [2380:root:12689]SSL state:TLSv1.3 early data:(null)(45.140.17.13)
2024-04-03 09:49:31 [2380:root:1268a]SSL state:before SSL initialization (45.140.17.13)
2024-04-03 09:49:31 [2380:root:1268a]SSL state:before SSL initialization (45.140.17.13)
2024-04-03 09:49:31 [2380:root:1268a]got SNI server name: dialup.balboaunited.org realm (null)
2024-04-03 09:49:31 [2380:root:1268a]client cert requirement: yes
2024-04-03 09:49:32 [2380:root:1268a]SSL state:SSLv3/TLS read client hello (45.140.17.13)
2024-04-03 09:49:32 [2380:root:1268a]SSL state:SSLv3/TLS write server hello (45.140.17.13)
2024-04-03 09:49:32 [2380:root:1268a]SSL state:SSLv3/TLS write change cipher spec (45.140.17.13)
2024-04-03 09:49:32 [2380:root:1268a]SSL state:TLSv1.3 early data (45.140.17.13)
2024-04-03 09:49:32 [2380:root:1268a]SSL state:TLSv1.3 early data:(null)(45.140.17.13)
2024-04-03 09:49:32 [2380:root:12687]SSL state:warning close notify (45.135.232.100)
2024-04-03 09:49:32 [2380:root:12687]sslConnGotoNextState:317 error (last state: 1, closeOp: 0)
2024-04-03 09:49:32 [2380:root:12687]Destroy sconn 0x7f07e0291000, connSize=49. (root)
2024-04-03 09:49:32 [2380:root:12687]SSL state:warning close notify (45.135.232.100)
2024-04-03 09:49:32 [2380:root:12688]SSL state:warning close notify (45.135.232.100)
2024-04-03 09:49:32 [2380:root:12688]sslConnGotoNextState:317 error (last state: 1, closeOp: 0)
2024-04-03 09:49:32 [2380:root:12688]Destroy sconn 0x7f07e0336800, connSize=48. (root)
2024-04-03 09:49:32 [2380:root:12688]SSL state:warning close notify (45.135.232.100)
2024-04-03 09:49:34 [2380:root:1268b]allocSSLConn:310 sconn 0x7f07e0291000 (0:root)
2024-04-03 09:49:34 [2380:root:1268c]allocSSLConn:310 sconn 0x7f07e0336800 (0:root)
2024-04-03 09:49:35 [2380:root:12689]epollFdHandler,566, sconn=0x7f07e0355000[121,-1,-1,-1,-1], fd=121, event=25.
2024-04-03 09:49:35 [2380:root:12689]epollFdHandler:636 s: 0x7f07e0355000 event: 0x19
2024-04-03 09:49:35 [2380:root:12689]Destroy sconn 0x7f07e0355000, connSize=49. (root)
2024-04-03 09:49:35 [2380:root:1268a]epollFdHandler,566, sconn=0x7f07e039a800[122,-1,-1,-1,-1], fd=122, event=25.
2024-04-03 09:49:35 [2380:root:1268a]epollFdHandler:636 s: 0x7f07e039a800 event: 0x19
2024-04-03 09:49:35 [2380:root:1268a]Destroy sconn 0x7f07e039a800, connSize=48. (root)
diag deb dis
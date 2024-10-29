|     |    |
|-----|------|
| User: | @{outputs('Get_response_details')?['body/responder']}|
| MAC ID: | @{outputs('Get_response_details')?['body/rc659f77f8184426f88e2cb4c8d823747']}|
|Reason: | @{outputs('Get_response_details')?['body/r07da83a2e383478bae0365c00367ee1d']} |


if(equals(outputs('Get_response_details')?['body/rc2b6e2865abb4963a4ca4108ca9ff955']'Other',outputs('Get_response_details')?['body/rc2b6e2865abb4963a4ca4108ca9ff955'],outputs('Get_response_details')?['body/r7e096b114fd9426bba8074c6f703e5b1'])

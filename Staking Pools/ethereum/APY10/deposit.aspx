<!DOCTYPE html>
<html><head>
<meta http-equiv="Content-type" content="text/html; charset=utf-8" /><meta http-equiv="X-UA-Compatible" content="IE=edge" /> <meta http-equiv="Content-language" content="en" />
<title>NEUY 10 Staking</title>
<link href="../../nodes_v1.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="./style.css" />
</head>
<body link="#FF0000" vlink="#FF0000" bgcolor="#FFFFFF" topmargin="0">
<center>
<table style="display:inline;color:black;width:90%;margin-top:90px;border:hidden;border-width:0px;border-color:black;text-align:center">
    <tr style="width:100%">

        <td valign="top"  style="text-align:center;width:100%;padding:20px;"> <br /><br /><br />
            <center><div style="width:220px;height:36px;margin-top:20px;overflow:hidden;padding:2px;background-color:#555555;color:white;border-radius:8px;font-size:17px;float:right"><div style="height:22px;float:left;width:90px;margin:5px;border-radius:5px; background-color:#666666;overflow:hidden" id="neuyBalance" onclick="getBalance()">0 NEUY</div><div style="height:22px;float:left;width:90px;margin:5px;margin-left:12px;overflow:hidden;border-radius:5px;background-color:dodgerblue" onclick="connect()" id="connectButton">Connect</div><div style="float:left;width:90px;margin:5px;margin-left:8px;overflow:hidden;" id="userAddress"></div></div>
                <div style="width:170px;height:36px;margin-top:20px;overflow:hidden;padding:2px;background-color:red;color:white;border-radius:8px;font-size:17px;float:right;margin-right:10px;padding-top:6px" id="wrongNetwork" hidden="hidden">Wrong Network</div>
                <div style="width:170px;height:36px;margin-top:20px;overflow:hidden;padding:2px;background-color:orange;color:white;border-radius:8px;font-size:17px;float:right;margin-right:10px;padding-top:6px" id="pendingDiv" hidden="hidden">Pending...</div>
                <br /><br />
                <div style="padding-top:60px">
                    <div style="text-align:left;width:700px;background-color:#EEEEEE;height:390px;border-radius:16px;padding:20px;">
                        <div style="font-size:20px;">Step 1. Get NEUY tokens</div><br />
                        <br />
                        <div style="font-size:14px;">NEUY tokens are required. Once you&#39;ve bought NEUY tokens, you can stake them in the pool for rewards.</div>
                        <a href="../swap.aspx"><div style="font-size:14px;">Get NEUY Token</div></a><br />
                        <div style="font-size:20px;">Step 2. Approve Transfer</div><br />
                        <br />
                        <div style="font-size:14px;">Enter amount you want to stake and &quot;Approve&quot; the transfer. Wait for approval transaction to complete. Once complete it can take upto <b>30secs</b> to show.</div><br />
                        <div style="font-size:20px;">Step 3. Stake Amount</div><br />
                        <br />
                        <div style="font-size:14px;">Deposit and done.<br /><br /> Always wait for transaction to complete. Use Metamask Activity tab to follow link to etherscan for blockchain confirmation. Once complete it can take upto <b>30secs</b> to show.</div><br />
                    </div>
                </div>

                <div style="margin-top:20px;margin-bottom:10px; font-size:24px;width:700px;text-align:left">  &nbsp;  Stake/Reward<img src="../../logo.png" width="27" height="27" style="float:left;margin-left:4px;" /><img src="../../logo.png" width="27" height="27" style="float:left;margin-left:4px;" /></div>
                <div style="padding-top:0px">

                    <div style="text-align:left;width:700px;background-color:red;border-radius:16px;padding:20px;color:white" id="errorMessageDiv" hidden="hidden">
                    </div>

                    <div style="margin-top:20px;text-align:left;width:700px;background-color:#EEEEEE;height:220px;border-radius:16px;padding:20px;">
                        <div style="font-size:24px;">&nbsp; Stake Amount (365- 50000 NEUY)</div>
                        <br />
                        <table style="width:100%;font-size:22px" cellspacing="10px">
                            <tr >
                                <td style="font-size:16px">
                                    <input style="width:100%;height:40px;font-size:28px" class="messageta" placeholder="0" type="text" id="depositInput"  size="48" maxlength="1024">
                                </td>
                                
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <center>
                                    <br /><br />
                                    <div onclick="depositStake()" style="cursor:pointer;margin-left:10px;float:right; border-radius:8px;width:220px;height:40px;padding:5px;padding-top:10px;background-color:dodgerblue;color:white;" hidden="hidden" id="depositButton">
                                        <b><center><span style="font-size:14px;">Deposit</span></center></b>
                                    </div> 
                                    <div onclick="approve()" style="cursor:pointer;float:right; border-radius:8px;width:220px;height:40px;padding:5px;padding-top:10px;background-color:dodgerblue;color:white;" id="approveButton">
                                        <b><center><span style="font-size:14px;" id="approveButtonTitle" >Approve</span></center></b>
                                    </div> 
                                    
                                    </center>
                                </td>
                            </tr>
                        </table>
                        <br />
                    </div>
                </div>
            </center>
        </td>    
    </tr>
</table>
</center>

<script
    src="https://cdn.ethers.io/lib/ethers-5.2.umd.min.js"
    type="application/javascript"
  ></script>
<script src="./script/app.js"></script>
</body></html>  
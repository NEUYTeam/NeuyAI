<!DOCTYPE html>
<html><head>
<style>
    /* Dropdown Button */
.dropbtn {
  background-color: dodgerblue;
  color: white;
  padding: 8px;
  margin-top:-3px;
  font-size: 18px;
  border: none;
  border-radius:8px;
  cursor: pointer;
  width: 170px;
}

/* Dropdown button on hover & focus */
.dropbtn:hover, .dropbtn:focus {
  background-color: #2980B9;
}

/* The container <div> - needed to position the dropdown content */
.dropdown {
  width:100%;
  position: relative;
  display: inline-block;
}

/* Dropdown Content (Hidden by Default) */
.dropdown-content {
  display: none;
  position: absolute;
  border-radius:8px;
  background-color: #f1f1f1;
  min-width: 170px;
  box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
  z-index: 1;
  overflow-y: scroll; 
  height:90px;
}

/* Links inside the dropdown */
.dropdown-content a {
  color: black;
  padding: 12px 16px;
  text-decoration: none;
  display: block;
}

/* Change color of dropdown links on hover */
.dropdown-content a:hover {background-color: #ddd}

/* Show the dropdown menu (use JS to add this class to the .dropdown-content container when the user clicks on the dropdown button) */
.show {display:block;}
</style>
<script>
    /* When the user clicks on the button,
toggle between hiding and showing the dropdown content */
    function showFromDropDown() {
        document.getElementById("fromDropdown").classList.toggle("show");
    }

    function showToDropDown() {
        document.getElementById("toDropdown").classList.toggle("show");
    }

    // Close the dropdown menu if the user clicks outside of it
    window.onclick = function (event) {
        if (!event.target.matches('.dropbtn')) {
            var dropdowns = document.getElementsByClassName("dropdown-content");
            var i;
            for (i = 0; i < dropdowns.length; i++) {
                var openDropdown = dropdowns[i];
                if (openDropdown.classList.contains('show')) {
                    openDropdown.classList.remove('show');
                }
            }
        }
    }
</script>
<meta http-equiv="Content-type" content="text/html; charset=utf-8" /><meta http-equiv="X-UA-Compatible" content="IE=edge" /> <meta http-equiv="Content-language" content="en" />
<title>NEUY 100 Staking</title>
<link href="../../nodes_v1.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="./style.css" />
</head>
<body link="#FF0000" vlink="#FF0000" bgcolor="#FFFFFF" topmargin="0">
<center>
<input type="hidden" id="neuyPrice" value="0.022">
<table style="display:inline;color:black;width:90%;margin-top:90px;border:hidden;border-width:0px;border-color:black;text-align:center">
    <tr style="width:100%">

        <td valign="top"  style="text-align:center;width:100%;padding:20px;"> <br /><br /><br />
            <center><div style="width:220px;height:36px;margin-top:20px;overflow:hidden;padding:2px;background-color:#555555;color:white;border-radius:8px;font-size:17px;float:right"><div style="height:22px;float:left;width:90px;margin:5px;border-radius:5px; background-color:#666666;overflow:hidden" id="neuyBalance" onclick="getBalance()">0 NEUY</div><div style="height:22px;float:left;width:90px;margin:5px;margin-left:12px;overflow:hidden;border-radius:5px;background-color:dodgerblue" onclick="connect()" id="connectButton">Connect</div><div style="float:left;width:90px;margin:5px;margin-left:8px;overflow:hidden;" id="userAddress"></div></div>
                <div style="width:170px;height:36px;margin-top:20px;overflow:hidden;padding:2px;background-color:red;color:white;border-radius:8px;font-size:17px;float:right;margin-right:10px;padding-top:6px" id="wrongNetwork" hidden="hidden">Wrong Network</div>
                <div style="width:170px;height:36px;margin-top:20px;overflow:hidden;padding:2px;background-color:orange;color:white;border-radius:8px;font-size:17px;float:right;margin-right:10px;padding-top:6px" id="pendingDiv" hidden="hidden">Pending...</div>
                <div style="width:170px;margin-right:10px;height:32px;margin-top:20px;padding:2px;color:white;border-radius:8px;font-size:17px;float:right">
                    <div  class="dropdown">
                        <button onclick="showFromDropDown()" class="dropbtn" id="fromTokenLabel" >Polygon ▼</button>
                        <div id="fromDropdown" class="dropdown-content">
                            <a href="../../ethereum/APY100/index.aspx" ><img src="https://dynamic-assets.coinbase.com/dbb4b4983bde81309ddab83eb598358eb44375b930b94687ebe38bc22e52c3b2125258ffb8477a5ef22e33d6bd72e32a506c391caa13af64c00e46613c3e5806/asset_icons/4113b082d21cc5fab17fc8f2d19fb996165bcce635e6900f7fc2d57c4ef33ae9.png" width="30" style="float:left;padding-left:10px;" />Ethereum</a>
                            <a href="../../polygon/APY100/index.aspx" "><img src="https://assets.coingecko.com/coins/images/4713/large/matic-token-icon.png?1624446912" width="30" style="float:left;padding-left:10px;" />Polygon</a>
                        </div>
                    </div>
                </div>
                <br /><br />
                <div style="padding-top:60px">
                    <div style="text-align:left;width:700px;background-color:#EEEEEE;height:160px;border-radius:16px;padding:20px;">
                        <div style="font-size:24px;">NEUY Staking Pool (Limited Supply)</div><br />
                        <div style="font-size:16px;">Stake your NEUY tokens to get even more NEUY tokens.</div><br />
                        <div style="font-size:14px;">Only 1,000,000 of founding tokens are used to fund pool rewards. Once allocated the Pool will be full. For more information, visit the NEUY Discord group.</div><br />
                    </div>
                </div>
                 <div style="padding-top:20px">
                    <div style="text-align:left;width:700px;background-color:#EEEEEE;height:280px;border-radius:16px;padding:20px;">
                        <div onclick="gotoDeposit()" style="cursor:pointer;border-radius:8px;float:right;width:120px;height:40px;padding:5px;padding-top:10px;background-color:dodgerblue;color:white" id="depositButton">
                            <b><center><span style="font-size:14px;">Deposit</span></center></b>
                        </div> 
                        <div style="font-size:34px;"><img style="float:left;margin-top:5px;" src="../../logo.png" width="32" />&nbsp;NEUY Pool (NEUY) </div>
                        <br />
                        <table style="width:100%;font-size:22px" cellspacing="10px">
                            <tr>
                                <td style="font-size:14px">
                                    Total Value Locked
                                </td>
                                <td style="font-size:14px;text-align:right">
                                    <b><span id="totalDeposited">$30128</span></b>
                                </td>
                            </tr>
                            <tr>
                                <td style="font-size:14px">
                                    Capacity
                                </td>
                                <td style="font-size:14px;text-align:right">
                                    <b><span id="capacity">100% Filled</span></b>
                                </td>
                            </tr>
                            <tr >
                                <td style="font-size:14px">
                                    Pool rate
                                </td>
                                <td style="font-size:14px;text-align:right">
                                    <b><span id="poolRate">15944.0 NEUY/week</span></b>
                                </td>
                            </tr>
                            <tr >
                                <td style="font-size:14px">
                                    APY rate
                                </td>
                                <td style="font-size:14px;text-align:right">
                                    <b>100.00%</b>
                                </td>
                            </tr>
                        </table>
                        <br />
                        * Your stake position will be shown below once you deposit NEUY tokens.
                        <br />
                        * With DeFi you are interacting with the blockchain directly, we don't store or collect any information.
                        <br /> * Transactions can take upto <b>30secs</b> to appear after completing. Refresh if required.
                    </div>
                </div> 
                
                <div style="padding-top:40px" hidden="hidden" id="positionDiv">
                    <div style="text-align:left;width:700px;background-color:#EEEEEE;height:250px;border-radius:16px;padding:20px;">
                        <div id="closeButton"  onclick="claimStakeAndReward()" style="cursor:pointer;border-radius:8px;float:right;width:120px;height:40px;padding:5px;padding-top:10px;background-color:dodgerblue;color:white;">
                            <b><center><span style="font-size:14px;">Claim</span></center></b>
                        </div>  
                        <div style="font-size:24px;">Position</div><br />
                        <table style="width:100%;font-size:22px" cellspacing="10px">
                            <tr >
                                <td style="font-size:16px">
                                    Total staked
                                </td>
                                <td style="font-size:16px;text-align:right">
                                    <b><span id="stakedNeuys">0.0 NEUY</span></b>
                                </td>
                            </tr>
                            <tr >
                                <td style="font-size:16px">
                                    Your unclaimed reward
                                </td>
                                <td style="font-size:16px;text-align:right">
                                    <b><span id="unclaimedRewards">0.0 NEUY</span></b>
                                </td>
                            </tr>
                            <tr >
                                <td style="font-size:16px">
                                    APY rate
                                </td>
                                <td style="font-size:16px;text-align:right">
                                    <b>100.00%</b>
                                </td>
                            </tr>
                        </table>
                        <br />
                        * Claim will only withdraw unclaimed rewards.
                        <br />
                        * Close withdraws both Staked amount as well as unclaimed Rewards.
                        <br />
                        * After the first 2hrs of staking, unclaimed rewards will begin to appear.
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
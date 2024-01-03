var provider = new ethers.providers.JsonRpcProvider('https://polygon-rpc.com');
var publicKey;
var privateKey = "";
var walletSigner;
var wallet;
var approvedAmount = 0;
var slippage = 0.98;
var pending = false;
var gasFeePrice = '80';
var arbing = false;
var expectedAmount = 0.0;
var profitPercentage = 1.01;
var profitAcceptedPercentage = 1.005;

var route1 = 0;
var route2 = 0;
var path1 = [];
var path2 = [];

const tokens = {
    matic: "0x0000000000000000000000000000000000001010",
    weth: "0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619",
    wmatic: "0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270",
    usdc: "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174",
    wbtc: "0x1BFD67037B42Cf73acF2047067bd4F2C47D9BfD6",
    aave: "0xD6DF932A45C0f255f85145f286eA0b292B21C90B",
    neuy: "0x62a872d9977Db171d9e213A5dc2b782e72ca0033",
    quick: "0xB5C064F955D8e7F38fE0460C556a72987494eE17",
    sol: "0x7DfF46370e9eA5f0Bad3C4E29711aD50062EA7A4"
}

const arbitrage = {
    address: "0xf3452c9a6b86ea4c3bce3d8b876c4a0e70f23d6f", 
    abi: [
        "function getArbitrageV2Quote(address[] path1, address[] path2, uint256 amountIn) external returns (uint256,uint256,uint256,uint256)",
        "function dexArbitrageV2Swap(uint256 route1, uint256 route2, uint256 amountIn, uint256 amountOutMin, address[] path1, address[] path2) external returns (uint256)",
        "function getV2QuoteWithPath(address[] path, uint256 amountIn) external returns (uint256,uint256)",
        "function dexV2SwapWithPath(uint256 route, uint256 amountIn, uint256 amountOutMin, address[] path) external returns (uint256)",
    ],
};

async function main() {
    provider.on("network", (newNetwork, oldNetwork) => {
        if (oldNetwork) {
            window.location.reload();
        }
    });

    privateKey = '0x0000000';
    publicKey = '0x0000000';
    
    //provider = new ethers.providers.JsonRpcProvider('https://polygon-rpc.com');
    //provider = new ethers.providers.JsonRpcProvider('https://polygon-mainnet.infura.io/v3/[APIKEY]');
    
    setInterval(getArbitrageQuote, 25000);
}

main();

async function getGasFeePrice() {
    try {
        let gFP = await provider.getGasPrice();
        let gFPWEI = ethers.utils.formatUnits(gFP, "gwei");
        if (gFPWEI < 60) {
            gasFeePrice = '125';
        } else {
            gasFeePrice = Math.round(gFPWEI * 1.8).toString();
        }
    } catch (err) {
        gasFeePrice = '125';
    }
}

async function getArbitrageQuote() {
    if (pending == true) { return }
    pending = true;
    publicKey = document.getElementById("publicKey").value;
    await getGasFeePrice();
    const signer = new ethers.VoidSigner(publicKey, provider);
    const tradeContract = new ethers.Contract(arbitrage.address, arbitrage.abi, signer);

    approvedAmount = document.getElementById("depositInput").value;
    expectedAmount = Math.round(approvedAmount * 0.5);
    console.log("min profit output: " + (approvedAmount * profitPercentage).toString());
    document.getElementById("target1").innerText = "min profit output: " + (approvedAmount * profitPercentage).toString();


    try {
        const output = await tradeContract.callStatic.getArbitrageV2Quote([tokens.wmatic, tokens.weth], [tokens.weth, tokens.wmatic],  ethers.utils.parseUnits(String(approvedAmount), Number("18")))
            .then(async (result) => {
                document.getElementById("route1").innerText = " route1: " + result[0].toString() + " output1: " + ethers.utils.formatUnits(result[1].toString(), Number("18")) + " route2: " + result[2].toString() + " output2: " + ethers.utils.formatUnits(result[3].toString(), Number("18"));
                pending = false;
                route1 = result[0].toString();
                route2 = result[2].toString();
                path1 = [tokens.wmatic, tokens.weth];
                path2 = [tokens.weth, tokens.wmatic];
                var arbValue = ethers.utils.formatUnits(result[3].toString(), Number("18"));
                if (arbValue >= (Number(approvedAmount) * profitPercentage)) {
                    console.log("arbitrage route1");
                    await arbitrageRoute1();
                }
            }, (error) => {
                console.log(error.toString());
                pending = false;
            });
    }
    catch (error) {
        console.log(error.toString());
        pending = false;
    }
}

async function arbitrageRoute1() {
    if (arbing == true) { return }
    arbing = true;

    publicKey = document.getElementById("publicKey").value;
    privateKey = document.getElementById("privateKey").value;

    wallet = new ethers.Wallet(privateKey);
    walletSigner = wallet.connect(provider);
    const signer = walletSigner;
    const tradeContract = new ethers.Contract(arbitrage.address, arbitrage.abi, signer);

    approvedAmount = document.getElementById("depositInput").value;
    var arbAmount = Math.round(approvedAmount * profitAcceptedPercentage);

    await getGasFeePrice();
    try {
        //NEUY to USDC to WETH to NEUY
        let arbitrageResult = await tradeContract.dexArbitrageV2Swap(route1, route2, ethers.utils.parseUnits(String(approvedAmount), Number("18")), ethers.utils.parseUnits(String(arbAmount), Number("18")), path1, path2, {
            gasPrice: ethers.utils.parseUnits(gasFeePrice, 'gwei').toString(),
            gasLimit: 500000,
        });

        arbitrageResult.wait().then(async (result) => {
                window.setTimeout(async () => {
                    arbing = false;
                }, 20000);
                console.log("Successful route1");
            }, (error) => {
                arbing = false;
                document.getElementById("route1").innerText = error.toString();
                console.log(error.toString());
            });
    }
    catch (err) {
        arbing = false;
    }
}
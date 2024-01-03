const provider = new ethers.providers.Web3Provider(window.ethereum, "any");
var addr;
var approvedAmount = 0;
var pending = false;
var gasFeePrice = '75';
const neuyropsten = {
    address: "0x62a872d9977Db171d9e213A5dc2b782e72ca0033",
    abi: [
        "function balanceOf(address account) external view returns (uint256)",
        "function approve(address spender, uint256 amount) external returns (uint256)",
        "function allowance(address owner, address spender) external view returns (uint256)",
    ],
};

const stakingropsten = {
    address: "0x8574f0F28Bbd7BCfFec50B00cc4D153C564bfC05",
    abi: [
        "function balanceOf(address account) external view returns (uint256)",       
        "function depositStake(uint256 amount) external",
        "function claimStakeAndReward()",
        "function checkContractAllowance() external view returns (uint256)",
        "function claimReward()",
        "function unclaimedReward() external view returns (uint256)",
        "function getRewardAmount() external view returns (uint256)",
        "function getStakedAmount() external view returns (uint256)",
        "function getSenderStakedAmount() external view returns (uint256)",
        "function getSenderStakeDate() external view returns (uint256)",
    ],
};

async function main() {
    provider.on("network", (newNetwork, oldNetwork) => {
        if (oldNetwork) {
            window.location.reload();
        }
    });
    window.ethereum.on('accountsChanged', () => {
        window.location.reload();
    });

    const signer = provider.getSigner();
    signer.getAddress()
        .then(async (address) => {
            document.getElementById("userAddress").innerText = address;
            addr = address;
            document.getElementById("userAddress").hidden = false;
            document.getElementById("connectButton").hidden = true;
            document.getElementById("depositButton").hidden = false;
            await getBalance();
            if (document.getElementById("depositInput") !== null) {
                await allowance();
            }
            await getSenderStake();
            await getGasFeePrice();
        })
        .catch((err) => {
            document.getElementById("userAddress").hidden = true;
            document.getElementById("connectButton").hidden = false;
            document.getElementById("depositButton").hidden = true;
            if (document.getElementById("approveButton") !== null) {
                document.getElementById("approveButton").hidden = true;
            }
        });
    await getStakeContractBalance();
    await totalStaked();
    await getCapacity();

    
}
main();

async function getGasFeePrice() {
    let gFP = await provider.getGasPrice();
    let gFPWEI = ethers.utils.formatUnits(gFP, "gwei");
    console.log(gFPWEI.toString());
    if (gFPWEI < 50) {
        console.log(gasFeePrice);
        gasFeePrice = '75';
    } else {
        console.log(gasFeePrice);
        gasFeePrice = Math.round(gFPWEI + 20.0).toString();
        console.log(gasFeePrice);
    }
}

async function allowance() {
    const signer = provider.getSigner();
    let userAddress = await signer.getAddress();
    const neuyContract = new ethers.Contract(neuyropsten.address, neuyropsten.abi, signer);
    let balance = await neuyContract.allowance(userAddress, stakingropsten.address)
        .then((balance) => {
            document.getElementById("depositInput").value = ethers.utils.formatEther(String(balance));
            approvedAmount = document.getElementById("depositInput").value;
            if (document.getElementById("depositButton") !== null) {
                document.getElementById("depositButton").style.backgroundColor = 'dodgerblue';
                document.getElementById("depositButton").hidden = false;
            }
            if (balance > 0) {
                if (document.getElementById("approveButtonTitle") !== null) {
                    document.getElementById("approveButtonTitle").innerText = "INCREASE APPROVE";
                }
            } else {
                document.getElementById("depositButton").hidden = true;
            }
        })
        .catch((err) => {
            if (document.getElementById("depositButton") !== null) {
                document.getElementById("depositButton").hidden = true;
                document.getElementById("approveButtonTitle").innerText = "APPROVE";
            }
        });
}

async function getBalance() {
    const signer = provider.getSigner();
    let userAddress = await signer.getAddress();
    const neuyContract = new ethers.Contract(neuyropsten.address, neuyropsten.abi, signer);
    let balance = await neuyContract.balanceOf(userAddress)
        .then((balance) => {
            document.getElementById("neuyBalance").innerText = Math.round(ethers.utils.formatEther(String(balance)));
            document.getElementById("wrongNetwork").hidden = true;
            if (document.getElementById("depositButton") !== null) {
                document.getElementById("depositButton").style.backgroundColor = 'dodgerblue';
            }
            if (document.getElementById("approveButton") !== null) {
                document.getElementById("approveButton").hidden = false;
            }
        })
        .catch((err) => {
            document.getElementById("wrongNetwork").hidden = false;
            if (document.getElementById("depositButton") !== null) {
                document.getElementById("depositButton").style.backgroundColor = '#999';
            }
            if (document.getElementById("approveButton") !== null) {
                document.getElementById("approveButton").hidden = true;
            }
        });
}

async function getUnclaimedReward() {
    const signer = provider.getSigner();
    let userAddress = await signer.getAddress();
    const stakeContract = new ethers.Contract(stakingropsten.address, stakingropsten.abi, signer);
    let balance = await stakeContract.unclaimedReward()
        .then((balance) => {
            if (document.getElementById("unclaimedRewards") !== null) {
                document.getElementById("unclaimedRewards").innerText = String(Math.round(ethers.utils.formatEther(balance) * 1000) / 1000.0) + ' NEUY';
            }
        })
        .catch((err) => {
            if (document.getElementById("unclaimedRewards") !== null) {
                document.getElementById("unclaimedRewards").innerText = '0.0 NEUY';
            }
        });
}

async function getSenderStake() {
    const signer = provider.getSigner();
    let userAddress = await signer.getAddress();
    const stakeContract = new ethers.Contract(stakingropsten.address, stakingropsten.abi, signer);
    let balance = await stakeContract.getSenderStakedAmount()
        .then((balance) => {
            if (document.getElementById("positionDiv") !== null && balance > 0) {
                document.getElementById("positionDiv").hidden = false;
            }
            document.getElementById("stakedNeuys").innerText = ethers.utils.formatEther(balance);
            getUnclaimedReward();
        })
        .catch((err) => {
            if (err != null) {
                if (document.getElementById("stakedNeuys") !== null) {
                    document.getElementById("stakedNeuys").innerText = "0.0 NEUY";
                }
            }
        });
}

async function totalStaked() {
    const signer = provider.getSigner();
    let userAddress = await signer.getAddress();
    const stakeContract = new ethers.Contract(stakingropsten.address, stakingropsten.abi, signer);
    let balance = await stakeContract.getStakedAmount()
        .then((balance) => {
            if (document.getElementById("poolRate") !== null) {
                document.getElementById("poolRate").innerText = Math.round(ethers.utils.formatEther(balance) / 52.0).toString() + " NEUY/week";
                console.log("successful poolRate")
            }
        });
        
}

//"function getRewardAmount() external view returns (uint256)",
//"function getStakedAmount() external view returns (uint256)",

async function getCapacity() {
    const signer = provider.getSigner();

    const stakingContract = new ethers.Contract(stakingropsten.address, stakingropsten.abi, signer);
    let reward = await stakingContract.getRewardAmount()
        .then(async (rewardAmount) => {
            
            let stake = await stakingContract.getStakedAmount()
                .then((stakeAmount) => {
                    var capacity = Math.round(ethers.utils.formatEther(String(stakeAmount)) / ethers.utils.formatEther(String(rewardAmount)) * 10000) / 100;
                    console.log(capacity);
                    if (capacity >= 100.0) {
                        if (document.getElementById("depositButton") !== null) {
                            document.getElementById("depositButton").hidden = true;
                        }
                        capacity = 100.0;
                    }
                    if (document.getElementById("capacity") !== null) {
                        document.getElementById("capacity").innerText = capacity.toString() + "% Filled";
                    }
                })
        })
}

async function getStakeContractBalance() {
    const signer = provider.getSigner();

    const neuyContract = new ethers.Contract(neuyropsten.address, neuyropsten.abi, signer);
    let balance = await neuyContract.balanceOf(ethers.utils.getAddress(stakingropsten.address))
        .then((balance) => {
            console.log(balance);
            if (document.getElementById("totalDeposited") !== null) {
                document.getElementById("totalDeposited").innerText = "$" + Math.round(ethers.utils.formatEther(String(balance)) * Number(document.getElementById("neuyPrice").value)).toString();
            }
        })
}

async function connect() {
    await provider.send("eth_requestAccounts", []);
    const signer = provider.getSigner();
    let userAddress = await signer.getAddress();
    document.getElementById("userAddress").innerText = userAddress;
    document.getElementById("userAddress").hidden = false;
    document.getElementById("connectButton").hidden = true;
    await getBalance();
}

async function approve() {
    if (pending == true) { return }
    await getGasFeePrice();
    const signer = provider.getSigner();
    const neuyContract = new ethers.Contract(neuyropsten.address, neuyropsten.abi, signer);
    approvedAmount = document.getElementById("depositInput").value;
    if (approvedAmount > 0) {
        let approval = await neuyContract.approve(stakingropsten.address, ethers.utils.parseEther(approvedAmount), {
            gasPrice: ethers.utils.parseUnits(gasFeePrice, 'gwei').toString(),
            gasLimit: 500000,
        });
        disableButtons();
        const receipt = await approval.wait(); 
        window.setTimeout(() => {
            location.reload();
        }, 30000);
    }
}

async function depositStake() {
    if (pending == true) { return }
    await getGasFeePrice();
    const signer = provider.getSigner();
    approvedAmount = document.getElementById("depositInput").value;
    const stakingContract = new ethers.Contract(stakingropsten.address, stakingropsten.abi, signer);
    let deposit = await stakingContract.depositStake(ethers.utils.parseEther(approvedAmount), {
        gasPrice: ethers.utils.parseUnits(gasFeePrice, 'gwei').toString(),
        gasLimit: 500000,
    });
    disableButtons();
    const receipt = await deposit.wait(); 
    window.setTimeout(() => {
        window.location.href = 'index.aspx';
    }, 30000);
    
}

async function claimReward() {
    if (pending == true) { return }
    await getGasFeePrice();
    const signer = provider.getSigner();
    const stakingContract = new ethers.Contract(stakingropsten.address, stakingropsten.abi, signer);
    let deposit = await stakingContract.claimReward({
        gasPrice: ethers.utils.parseUnits(gasFeePrice, 'gwei').toString(),
        gasLimit: 500000,
    });
    disableButtons();
    const receipt = await deposit.wait(); 
    window.setTimeout(() => {
        location.reload();
    }, 30000);
    
}

async function claimStakeAndReward() {
    if (pending == true) { return }
    await getGasFeePrice();
    const signer = provider.getSigner();
    const stakingContract = new ethers.Contract(stakingropsten.address, stakingropsten.abi, signer);
    let deposit = await stakingContract.claimStakeAndReward({
        gasPrice: ethers.utils.parseUnits(gasFeePrice, 'gwei').toString(),
        gasLimit: 500000,
    });
    disableButtons();
    const receipt = await deposit.wait(); 
    window.setTimeout(() => {
        location.reload();
    }, 30000);
}

function gotoDeposit() {
    window.location.href = 'deposit.aspx';
}

function disableButtons() {
    document.getElementById("pendingDiv").hidden = false;
    pending = true;
    if (document.getElementById("closeButton") !== null) {
        document.getElementById("closeButton").style.backgroundColor = '#999';
    }
    if (document.getElementById("approveButton") !== null) {
        document.getElementById("approveButton").style.backgroundColor = '#999';
    }
    if (document.getElementById("depositButton") !== null) {
        document.getElementById("depositButton").style.backgroundColor = '#999';
    }
}


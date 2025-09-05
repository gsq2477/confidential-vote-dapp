const contractAddress = 'YOUR_CONTRACT_ADDRESS'; // 替换为部署后的地址
const abi = [ /* 从 Solidity 编译后复制 ABI */ ]; // 使用 Hardhat 或 Remix 获取 ABI

let provider, signer, contract;

document.getElementById('connectWallet').addEventListener('click', async () => {
    provider = new ethers.providers.Web3Provider(window.ethereum);
    await provider.send('eth_requestAccounts', []);
    signer = provider.getSigner();
    contract = new ethers.Contract(contractAddress, abi, signer);
    document.getElementById('proposalForm').classList.remove('hidden');
    document.getElementById('voteForm').classList.remove('hidden');
});

document.getElementById('createProposal').addEventListener('click', async () => {
    const desc = document.getElementById('proposalDesc').value;
    const duration = document.getElementById('duration').value;
    await contract.createProposal(desc, duration);
    alert('Proposal Created!');
});

async function generateFHEEncryptedVote(choice, shares) {
    const timestamp = Date.now();
    const account = await signer.getAddress();
    const userSeed = ethers.utils.keccak256(ethers.utils.toUtf8Bytes(`${account}_${timestamp}`));
    const encryptedChoice = ethers.utils.keccak256(
        ethers.utils.solidityPack(['uint256', 'uint256', 'bytes32'], [choice, timestamp, userSeed])
    );
    const encryptedShares = ethers.utils.keccak256(
        ethers.utils.solidityPack(['uint256', 'uint256', 'bytes32'], [shares, timestamp, userSeed])
    );
    const zkProof = ethers.utils.solidityPack(
        ['bytes32', 'bytes32', 'uint256', 'address'],
        [encryptedChoice, encryptedShares, timestamp, account]
    );
    return { encryptedChoice, encryptedShares, zkProof };
}

document.getElementById('castVote').addEventListener('click', async () => {
    const proposalId = document.getElementById('proposalId').value;
    const choice = document.getElementById('choice').value;
    const shares = document.getElementById('shares').value;
    const { encryptedChoice, encryptedShares, zkProof } = await generateFHEEncryptedVote(choice, shares);
    await contract.castEncryptedVote(proposalId, encryptedChoice, encryptedShares, zkProof);
    alert('Vote Cast!');
});

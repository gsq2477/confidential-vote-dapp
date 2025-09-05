# ConfidentialVote - FHE-Powered Corporate Governance DApp

## 项目概述
这是一个使用 Zama Fully Homomorphic Encryption (FHE) 技术的公司治理平台，支持保密股东投票。投票过程加密，确保隐私，同时结果透明。适用于董事会选举、预算批准等。

## 关键原则
- **保密投票**：使用 FHE 加密投票数据。
- **公司治理**：支持战略决策，如董事会选举和股息政策。
- **实时验证**：结合零知识证明 (ZK) 确保有效性。
- **去中心化**：基于 Ethereum 区块链。
- **透明结果**：聚合结果公开，但个人投票隐私。

## 用例
- 董事会成员选举
- 股息分配政策
- 预算批准

## 前端使用指南
1. 使用 MetaMask 连接 Sepolia 测试网。
2. 验证股东身份。
3. 创建提案（董事会成员）。
4. 投票（股东）。
5. 查看结果。

用户角色：
- **董事会成员**：创建提案。
- **股东**：投票。

界面：响应式设计，集成 MetaMask。

## 技术架构
- **智能合约层**：Zama fhEVM、OpenZeppelin 安全库。
- **前端**：Vanilla JavaScript、Ethers.js、TailwindCSS、FHE 客户端库。
- **部署**：Ethereum Sepolia 测试网，未来 IPFS 存储。

## 核心功能实现
- FHE 加密：前端加密投票。
- 智能合约：存储加密投票，聚合结果。
- 访问控制：仅验证股东可投票。

## 开发与部署
### 先决条件
- Node.js v18+
- MetaMask
- Git

### 安装
1. 克隆仓库：`git clone https://github.com/您的用户名/my-zama-dapp.git`
2. 安装依赖：`npm install`
3. 配置 .env：复制 .env.example，添加合约地址。

### 本地开发
- 运行前端：`npm start` 或打开 index.html。
- 部署合约：使用 Hardhat 到 Sepolia 测试网。

### 测试
- 智能合约测试：使用 Mocha。
- 前端测试：浏览器模拟投票。
- 安全审计：Gas 优化，FHE 兼容性。

## 许可证
MIT License

## 贡献
欢迎 PR！贡献领域：FHE 优化、前端改进、安全增强。

## 安全考虑
- 仅测试网使用。
- FHE 为实验技术。

## 限制
- Gas 成本高。
- 浏览器兼容性（Chrome 最佳）。

## 路线图
- Q4 2025：主网部署。
- Q1 2026：移动 App。

## 支持
加入 Zama Discord：https://discord.gg/zama
更多：https://www.zama.ai/developer-program

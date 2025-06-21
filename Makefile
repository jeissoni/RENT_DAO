include .env

deploy_dao_rent:
	forge script script/deploy_DAO_RENT.s.sol:DeployDAO_RENT --rpc-url ${SEPOLIA_RPC_URL} --broadcast --etherscan-api-key ${ETHERSCAN_API_KEY} --verify etherscan -vvvv

deploy_mock_usdt:
	forge script script/Deploy_Mock_USDT.s.sol:Deploy_Mock_USDT --rpc-url ${SEPOLIA_RPC_URL} --broadcast --etherscan-api-key ${ETHERSCAN_API_KEY} --verify etherscan -vvvv
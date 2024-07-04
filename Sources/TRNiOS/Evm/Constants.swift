import Foundation

public let ERC1155_ABI = ERC1155_PRECOMPILE_ABI
public let ERC20_ABI = ERC20_PRECOMPILE_ABI
public let ERC721_ABI = ERC721_PRECOMPILE_ABI
public let FEE_PROXY_ABI = FEE_PROXY_PRECOMPILE_ABI

// Precompile address for nft precompile is 1721
let NFT_PRECOMPILE_ADDRESS = "0x00000000000000000000000000000000000006b9"
// Precompile address for sft precompile is 1731
let SFT_PRECOMPILE_ADDRESS = "0x00000000000000000000000000000000000006c3"
// Precompile address for futurepass registrar precompile is 65535
let FUTUREPASS_REGISTRAR_PRECOMPILE_ADDRESS = "0x000000000000000000000000000000000000FFFF"

// Precompile address for peg precompile is 1939
let PEG_PRECOMPILE_ADDRESS = "0x0000000000000000000000000000000000000793"

// Precompile address for dex precompile
let DEX_PRECOMPILE_ADDRESS = "0x000000000000000000000000000000000000DDDD"

// Precompile address for fee proxy
let FEE_PROXY_PRECOMPILE_ADDRESS = "0x00000000000000000000000000000000000004bb"

/** ABIs */

let SFT_PRECOMPILE_ABI = [
    "event InitializeSftCollection(address indexed collectionOwner, address indexed precompileAddress)",
    "function initializeCollection(address owner, bytes name, bytes metadataPath, address[] royaltyAddresses, uint32[] royaltyEntitlements) returns (address, uint32)",
]

let FEE_PROXY_PRECOMPILE_ABI = [
    "function callWithFeePreferences(address asset, uint128 maxPayment, address target, bytes input)",
]

let ERC20_PRECOMPILE_ABI = [
    "event Transfer(address indexed from, address indexed to, uint256 value)",
    "event Approval(address indexed owner, address indexed spender, uint256 value)",
    "function approve(address spender, uint256 amount) public returns (Bool)",
    "function allowance(address owner, address spender) public view returns (uint256)",
    "function balanceOf(address who) public view returns (uint256)",
    "function name() public view returns (String)",
    "function symbol() public view returns (String)",
    "function decimals() public view returns (UInt8)",
    "function transfer(address who, uint256 amount)",
]

let NFT_PRECOMPILE_ABI = [
    "event InitializeCollection(address indexed collectionOwner, address precompileAddress)",
    "function initializeCollection(address owner, bytes name, uint32 maxIssuance, bytes metadataPath, address[] royaltyAddresses, uint32[] royaltyEntitlements) returns (address, uint32)",
]

let OWNABLE_ABI = [
    "event OwnershipTransferred(address indexed previousOwner, address indexed newOwner)",
    "function owner() public view returns (address)",
    "function renounceOwnership()",
    "function transferOwnership(address owner)",
]

let ERC721_PRECOMPILE_ABI = [
    // ERC721
    "event Transfer(address indexed from, address indexed to, uint256 indexed tokenId)",
    "event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId)",
    "event ApprovalForAll(address indexed owner, address indexed operator, Bool approved)",

    "function balanceOf(address who) public view returns (uint256)",
    "function ownerOf(uint256 tokenId) public view returns (address)",
    "function safeTransferFrom(address from, address to, uint256 tokenId)",
    "function transferFrom(address from, address to, uint256 tokenId)",
    "function approve(address to, uint256 tokenId)",
    "function getApproved(uint256 tokenId) public view returns (address)",
    "function setApprovalForAll(address operator, Bool _approved)",
    "function isApprovedForAll(address owner, address operator) public view returns (Bool)",

    // ERC721 Metadata
    "function name() public view returns (String)",
    "function symbol() public view returns (String)",
    "function tokenURI(uint256 tokenId) public view returns (String)",

    // Root specific precompiles
    "event MaxSupplyUpdated(uint32 maxSupply)",
    "event BaseURIUpdated(String baseURI)",

    "function totalSupply() external view returns (uint256)",
    "function mint(address owner, uint32 quantity)",
    "function setMaxSupply(uint32 maxSupply)",
    "function setBaseURI(bytes baseURI)",
    "function ownedTokens(address who, uint16 limit, uint32 cursor) public view returns (uint32, uint32, [uint32])",

    // Ownable
] + OWNABLE_ABI

let ERC1155_PRECOMPILE_ABI = [
    // ERC1155
    "event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value)",
    "event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] balances)",
    "event ApprovalForAll(address indexed account, address indexed operator, Bool approved)",

    "function balanceOf(address owner, uint256 id) external view returns (uint256)",
    "function balanceOfBatch(address[] owners, uint256[] ids) external view returns ([uint256])",
    "function setApprovalForAll(address operator, Bool approved) external",
    "function isApprovedForAll(address account, address operator) external view returns (Bool)",
    "function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external",
    "function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external",

    // Burnable
    "function burn(address account, uint256 id, uint256 value) external",
    "function burnBatch(address account, uint256[] ids, uint256[] values) external",

    // Supply
    "function totalSupply(uint256 id) external view returns (uint256)",
    "function exists(uint256 id) external view returns (Bool)",

    // Metadata
    "function uri(uint256 id) external view returns (String)",

    // TRN
    "event TokenCreated(uint32 indexed serialNumber)",
    "event MaxSupplyUpdated(uint128 indexed maxSupply)",
    "event BaseURIUpdated(String baseURI)",

    "function createToken(bytes name, uint128 initialIssuance, uint128 maxIssuance, address tokenOwner) external returns (uint32)",
    "function mint(address owner, uint256 id, uint256 amount) external",
    "function mintBatch(address owner, uint256[] ids, uint256[] amounts) external",
    "function setMaxSupply(uint256 id, uint32 maxSupply) external",
    "function setBaseURI(bytes baseURI) external",

    // Ownable
] + OWNABLE_ABI

let FUTUREPASS_PRECOMPILE_ABI = [
    // Futurepass
    "event FuturepassDelegateRegistered(address indexed futurepass, address indexed delegate, uint8 proxyType)",
    "event FuturepassDelegateUnregistered(address indexed futurepass, address delegate)",
    "event Executed(uint8 indexed callType, address indexed target, uint256 indexed value, bytes4 data)",
    "event ContractCreated(uint8 indexed callType, address indexed contractAddress, uint256 indexed value, bytes32 salt)",

    "function delegateType(address delegate) external view returns (uint8)",

    "function registerDelegateWithSignature(address delegate, uint8 proxyType, uint32 deadline, bytes memory signature) external",
    "function unregisterDelegate(address delegate) external",
    "function proxyCall(uint8 callType, address callTo, uint256 value, bytes memory callData) external payable",

    // Ownable
] + OWNABLE_ABI

let FUTUREPASS_REGISTRAR_PRECOMPILE_ABI = [
    "event FuturepassCreated(address indexed futurepass, address owner)",
    "function futurepassOf(address owner) external view returns (address)",
    "function create(address owner) external returns (address)",
]

let DEX_PRECOMPILE_ABI = [
    "function addLiquidity(address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) returns (uint256 amountA, uint256 amountB, uint256 liquidity)",
    "function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity)",
    "function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) pure returns (uint256 amountIn)",
    "function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) pure returns (uint256 amountOut)",
    "function getAmountsIn(uint256 amountOut, address[] path) view returns ([uint256])",
    "function getAmountsOut(uint256 amountIn, address[] path) view returns ([uint256])",
    "function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) pure returns (uint256 amountB)",
    "function removeLiquidity(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) returns (uint256 amountA, uint256 amountB)",
    "function removeLiquidityETH(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) returns (uint256 amountToken, uint256 amountETH)",
    "function swapETHForExactTokens(uint256 amountOut, address[] path, address to, uint256 deadline) payable returns ([uint256])",
    "function swapExactETHForTokens(uint256 amountOutMin, address[] path, address to, uint256 deadline) payable returns ([uint256])",
    "function swapExactTokensForETH(uint256 amountIn, uint256 amountOutMin, address[] path, address to, uint256 deadline) returns ([uint256])",
    "function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] path, address to, uint256 deadline) returns ([uint256])",
    "function swapTokensForExactETH(uint256 amountOut, uint256 amountInMax, address[] path, address to, uint256 deadline) returns ([uint256])",
    "function swapTokensForExactTokens(uint256 amountOut, uint256 amountInMax, address[] path, address to, uint256 deadline) returns ([uint256])",
]

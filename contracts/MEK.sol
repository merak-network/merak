// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract Ownable {
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    constructor () {
        address msgSender = msg.sender;
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }
    function owner() public view virtual returns (address) {
        return _owner;
    }
    modifier onlyOwner() {
        require(owner() == msg.sender, "Ownable: caller is not the owner");
        _;
    }
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

library SafeMath {
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function burn(address account, uint256 amount) external;
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface IBoard {
    function allocateWithToken(uint256 amount1, uint256 amount2) external;
    function allocate(uint256 amount1, uint256 amount2) external;
}

/**
 * to recieve USDT from uniswapV2Router when swaping
 */
contract ReceiveUsdt is Ownable {
    IERC20 public usdt;
    constructor (address usdt_) {
        usdt = IERC20(usdt_);
    }

    function transferBack(uint256 amount) public onlyOwner{
        usdt.transfer(owner(), amount);
    }
}

contract MEK is IERC20, Ownable {
    using SafeMath for uint256;

    mapping (address => uint256) internal _balances;
    mapping (address => mapping (address => uint256)) internal _allowances;
    uint256 internal _totalSupply;

    string private _name = "MEK";
    string private _symbol = "MEK";
    uint8 private _decimals = 18;

    mapping(address => bool) public fromWhiteList;
    mapping(address => bool) public toWhiteList;
    mapping(address => bool) public pairList;
    mapping(address => bool) public poolList;

    IERC20 public usdt;
    IUniswapV2Router02 public uniswapV2Router;
    IBoard board;
    IERC20 public burnToken;
    ReceiveUsdt public receiveUsdt;
    address public uniswapV2Pair;
    uint256 public burnRatio = 1;
    uint256 public burnNumber = 0.1e18;
    uint256 public boardPct = 80;
    uint256 public lpPct = 20;
    address public liquidityWallet;
    address public lpAddress;
    address public techAddress;
    address public foundAddress;

    bool public removeFee;
    bool inSwapAndLiquify;
    bool public swapAndLiquifyEnabled = true;
    uint256 public numTokensSellToAddToLiquidity = 200 * 1e18;
    uint256 public total = 2.1 * 1e8 * 1e18;

    event SwapAndLiquify(uint256 tokensSwapped, uint256 usdtReceived, uint256 tokensIntoLiqudity);

    constructor (address _usdt, address _router, address _lpAddress, address _techAddress, address _foundAddress) {
        usdt = IERC20(_usdt);
        uniswapV2Router = IUniswapV2Router02(_router);
        receiveUsdt = new ReceiveUsdt(address(usdt));
        // Create a uniswap pair for this new token
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
        .createPair(address(this), address(usdt));
        
        liquidityWallet = _lpAddress;
        lpAddress = _lpAddress;
        techAddress = _techAddress;
        foundAddress = _foundAddress;
        _mint(owner(), total.mul(90).div(100).add(1e18));
        _mint(lpAddress, total.mul(1).div(100).sub(1e18));
        _mint(techAddress, total.mul(4).div(100));
        _mint(foundAddress, total.mul(5).div(100));
        fromWhiteList[owner()] = true;
        toWhiteList[owner()] = true;
        fromWhiteList[lpAddress] = true;
        fromWhiteList[techAddress] = true;
        fromWhiteList[foundAddress] = true;

        fromWhiteList[address(this)] = true;
        toWhiteList[address(this)] = true;
        pairList[uniswapV2Pair] = true;
    }

    function init(address _burnToken, address _board, address[] memory pools) public onlyOwner(){
        burnToken = IERC20(_burnToken);
        board = IBoard(_board);
        setPoolList(pools, true);
    }

    modifier onlyBurnToken{
        require(msg.sender == address(burnToken), 'Can\'t burn');
        _;
    }

    modifier lockTheSwap {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    function setPoolList(address[] memory addrs, bool flag) public onlyOwner() {
        for(uint i=0;i<addrs.length;i++){
            poolList[addrs[i]] = flag;
        }
    }

    function setPairList(address[] memory addrs, bool flag) public onlyOwner() {
        for(uint i=0;i<addrs.length;i++){
            pairList[addrs[i]] = flag;
        }
    }

    function setBoard(address _board) public onlyOwner(){
        board = IBoard(_board);
    }

    // 0 from; 1 to; 2 both;
    function setWhiteList(address[] memory addrs, uint fromOrToOrBoth, bool flag) public onlyOwner() {
        if(fromOrToOrBoth == 0){
            for(uint i=0;i<addrs.length;i++){
                fromWhiteList[addrs[i]] = flag;
            }
        }else if(fromOrToOrBoth == 1){
            for(uint i=0;i<addrs.length;i++){
                toWhiteList[addrs[i]] = flag;
            }
        }else if(fromOrToOrBoth == 2){
            for(uint i=0;i<addrs.length;i++){
                fromWhiteList[addrs[i]] = flag;
                toWhiteList[addrs[i]] = flag;
            }
        }
    }

    function changeRemoveFee(bool flag) public onlyOwner(){
        removeFee = flag;
    }

    function changePct(uint _boardPct, uint _lpPct) public onlyOwner(){
        boardPct = _boardPct;
        lpPct = _lpPct;
    }

    function changeLiquidityWallet(address _liquidityWallet) public onlyOwner(){
        liquidityWallet = _liquidityWallet;
    }

    function changeBurnRatio(uint ratio) public onlyOwner(){
        burnRatio = ratio;
    }
    
    function changeBurnNumber(uint number) public onlyOwner(){
        burnNumber = number;
    }

    function changeSwapAndLiquifyEnabled(bool _swapAndLiquifyEnabled) public onlyOwner(){
        swapAndLiquifyEnabled = _swapAndLiquifyEnabled;
    }

    function changeRouterAddress(address newRouter) public onlyOwner() {
        uniswapV2Router = IUniswapV2Router02(newRouter);
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), address(usdt));
    }

    function changeNumToAddToLiquidity(uint256 num) public onlyOwner() {
        numTokensSellToAddToLiquidity = num;
    }

    function isContract(address addr) public view returns (bool){
        uint size;
        assembly {
            size := extcodesize(addr)
        }
        return size > 0;
    }

    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
        uint256 half = contractTokenBalance.div(2);
        uint256 otherHalf = contractTokenBalance.sub(half);
        uint256 initialBalance = usdt.balanceOf(address(receiveUsdt));

        swapTokensForToken(half);

        uint256 newBalance = usdt.balanceOf(address(receiveUsdt)).sub(initialBalance);
        receiveUsdt.transferBack(newBalance);
        addLiquidity(otherHalf, newBalance);
        emit SwapAndLiquify(half, newBalance, otherHalf);
    }

    function swapTokensForToken(uint256 tokenAmount) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = address(usdt);

        _approve(address(this), address(uniswapV2Router), tokenAmount);

        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(receiveUsdt),
            block.timestamp
        );
    }

    function addLiquidity(uint256 tokenAmount, uint256 usdtAmount) private {
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        usdt.approve(address(uniswapV2Router), usdtAmount);

        uniswapV2Router.addLiquidity(
            address(this),
            address(usdt),
            tokenAmount,
            usdtAmount,
            0,
            0,
            liquidityWallet,
            block.timestamp
        );
    }

    function sendFees(address sender, uint256 _amount) internal returns(uint256){
        uint256 toBoard = boardPct.mul(_amount).div(1000);
        uint256 toLp = lpPct.mul(_amount).div(1000);
        uint256 toFee = toBoard.add(toLp);

        _balances[sender] = _balances[sender].sub(toFee);

        _balances[address(board)] = _balances[address(board)].add(toBoard);
        emit Transfer(sender, address(board), toBoard);
        // try board.allocate(toBoard, 0) {} catch {}
        board.allocate(toBoard, 0);

        _balances[address(this)] = _balances[address(this)].add(toLp);
        emit Transfer(sender, address(this), toLp);

        return toFee;
    }

    function burn(address account, uint256 amount) public override onlyBurnToken{
        _burn(account, amount);
    }

    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        // is the token balance of this contract address over the min number of
        // tokens that we need to initiate a swap + liquidity lock?
        // also, don't get caught in a circular liquidity event.
        // also, don't swap & liquify if sender is uniswap pair.
        uint256 contractTokenBalance = balanceOf(address(this));
        bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
        if (
            overMinTokenBalance &&
            !inSwapAndLiquify &&
            sender != uniswapV2Pair &&
            swapAndLiquifyEnabled
        ) {
            contractTokenBalance = numTokensSellToAddToLiquidity;
            swapAndLiquify(contractTokenBalance);
        }
        
        if(!inSwapAndLiquify && !fromWhiteList[sender] && !toWhiteList[recipient]){
            if(!isContract(sender) && burnNumber>0){
                burnToken.burn(sender, burnNumber);
            }
            uint256 toBurn;
            if(burnRatio>0){
                toBurn = amount.mul(burnRatio).div(100);
                _burn(sender, toBurn);
            }
            if(!removeFee && (poolList[sender] || pairList[recipient])){
                uint256 feeAmount = sendFees(sender, amount);
                amount = amount.sub(feeAmount);
            }
            amount = amount.sub(toBurn);
        }

        _beforeTokenTransfer(sender, recipient, amount);
        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");
        _beforeTokenTransfer(address(0), account, amount);
        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");
        _beforeTokenTransfer(account, address(0), amount);
        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _setupDecimals(uint8 decimals_) internal virtual {
        _decimals = decimals_;
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}

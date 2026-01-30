  
## 函数参数传递  
  
### 引用传递 vs 值传递  
  
#### 引用传递（推荐）  
```cpp  
std::string buildHttpResponse(const std::string& content) {  
    // 使用引用，不复制字符串  
    return "HTTP/1.1 200 OK\r\n\r\n" + content;}  
```  
  
**语法解释**：  
- `std::string&` - 引用类型  
- `const` - 表示不能修改参数  
- `content` - 参数名  
  
**优点**：  
1. **效率高** - 不复制数据，直接使用原对象  
2. **节省内存** - 不创建新的副本  
3. **安全** - const 防止意外修改  
  
#### 值传递（不推荐用于大对象）  
```cpp  
std::string buildHttpResponse(std::string content) {  // 会复制整个字符串  
    return "HTTP/1.1 200 OK\r\n\r\n" + content;}  
```  
  
### 引用 vs 指针  
  
| 特性 | 引用 | 指针 |  
|------|------|------|  
| 空值 | 不能为空 | 可能为 nullptr |  
| 语法 | 直接使用 | 需要 * 解引用 |  
| 重新赋值 | 不能指向别的对象 | 可以重新指向 |  
| 安全性 | 更安全 | 需要检查空指针 |  
  
**引用示例**：  
```cpp  
void processData(const std::string& data) {  
    // 直接使用，不需要检查空值  
    std::cout << data << std::endl;}  
```  
  
**指针示例**：  
```cpp  
void processData(const std::string* data) {  
    if (data != nullptr) {  // 必须检查空指针  
        std::cout << *data << std::endl;  // 需要解引用  
    }}  
```  
  
**什么时候用指针？**  
- 可选参数（可能为空）  
- 需要重新指向不同对象  
- C风格数组操作  
  
## 数组初始化  
  
### 原始数组  
```cpp  
char buffer[4096] = {0};  // 手动初始化所有元素为0  
```  
  
**为什么需要 `{0}`？**  
- 原始数组不会自动初始化  
- 不初始化会包含随机垃圾数据  
- `{0}` 把所有元素都设为0  
  
**等价写法**：  
```cpp  
char buffer[4096];  
memset(buffer, 0, 4096);  // 手动清零  
```  
  
### 字符串对象  
```cpp  
std::string response_content;  // 自动初始化为空字符串  
```  
  
**为什么不需要手动初始化？**  
- `std::string` 是类对象，有默认构造函数  
- 构造函数自动初始化为空字符串 `""`  
- 自动管理内存  
  
## 类型转换  
  
### 数组到字符串  
```cpp  
char buffer[4096] = {0};  
std::string request = buffer;  // 自动类型转换  
```  
  
**转换过程**：  
1. `buffer` (char数组) → `char*` (数组名转换为指针)  
2. `char*` → `std::string` (调用构造函数)  
  
**等价写法**：  
```cpp  
std::string request(buffer);       // 显式构造函数调用  
std::string request = std::string(buffer);  // 更明确的写法  
```  
  
## 原始字符串字面量  
  
### R"( )" 语法  
```cpp  
response_content = R"(  
<!DOCTYPE html>  
<html>  
<head>  
    <title>Hello World</title></head>  
<body>  
    <h1>Hello from C++ HTTP Server!</h1></body>  
</html>  
)";  
```  
  
**优点**：  
- 保持原始格式（换行、缩进）  
- 不需要转义特殊字符  
- 提高可读性  
  
**对比普通字符串**：  
```cpp  
// 原始字符串 - 易读  
std::string html = R"(<h1>Hello "World"!</h1>)";  
  
// 普通字符串 - 需要转义  
std::string html = "<h1>Hello \"World\"!</h1>";  
```  
  
## 构造函数和初始化  
  
### 构造函数语法  
```cpp  
SimpleHttpServer(int p) : port(p), server_fd(-1) {}  
```  
  
**组成部分**：  
1. `SimpleHttpServer(int p)` - 构造函数声明  
2. `: port(p), server_fd(-1)` - 初始化列表  
3. `{}` - 构造函数体（这里为空）  
  
### 初始化列表 vs 构造函数体赋值  
  
#### 初始化列表（推荐）  
```cpp  
SimpleHttpServer(int p) : port(p), server_fd(-1) {}  
```  
  
**执行过程**：  
1. 直接用指定值初始化成员变量  
2. 效率高，一步到位  
  
#### 构造函数体赋值  
```cpp  
SimpleHttpServer(int p) {  
    port = p;        // 先默认初始化，再赋值  
    server_fd = -1;}  
```  
  
**执行过程**：  
1. 成员变量先用随机值初始化  
2. 进入构造函数体  
3. 重新赋值（两步操作，效率低）  
  
### 为什么初始化列表更好？  
  
| 方面 | 初始化列表 | 构造函数体赋值 |  
|------|------------|----------------|  
| 效率 | 高（直接初始化） | 低（初始化+赋值） |  
| const成员 | ✅ 支持 | ❌ 编译错误 |  
| 引用成员 | ✅ 支持 | ❌ 编译错误 |  
| 可读性 | 清晰表示初始化 | 容易混淆 |  
  
**const 和引用成员示例**：  
```cpp  
class Example {  
    const int id;        // const成员必须初始化  
    int& ref;           // 引用成员必须初始化  
public:  
    // ✅ 正确：使用初始化列表  
    Example(int i, int& r) : id(i), ref(r) {}    // ❌ 错误：const和引用不能在构造函数体内赋值  
    // Example(int i, int& r) {    //     id = i;      // 编译错误！  
    //     ref = r;     // 编译错误！  
    // }};  
```  
  
## 类型比较：原始类型 vs 类对象  
  
### 原始类型（需要手动初始化）  
```cpp  
int num;           // ❌ 包含垃圾值  
char arr[100];     // ❌ 包含垃圾值  
double price;      // ❌ 包含垃圾值  
  
// 正确写法：  
int num = 0;  
char arr[100] = {0};  
double price = 0.0;  
```  
  
### 类对象（自动初始化）  
```cpp  
std::string str;           // ✅ 自动初始化为 ""std::vector<int> vec;      // ✅ 自动初始化为空向量  
std::map<int,int> map;     // ✅ 自动初始化为空映射  
```  
  
**结论**：这就是为什么C++推荐使用标准库的类对象而不是原始类型 - 更安全，更方便！  
  
---  
  
## 学习建议  
  
1. **多练习**：通过编写小程序来熟悉语法  
2. **理解原理**：不只是记住语法，要理解为什么这样设计  
3. **对比学习**：和你熟悉的PHP、Go语法对比  
4. **安全第一**：优先选择安全的写法（引用、初始化列表、类对象）  
5. **现代C++**：学习C++11及以后的特性（如原始字符串）  
  
记住：C++虽然复杂，但这些复杂性都是为了性能和安全性服务的！  
  
## 库链接系统  
  
### 链接的核心目的  
**把分散的代码片段组装成完整的可执行程序**  
  
### 编译 vs 链接过程  
```  
源代码阶段    →    编译阶段    →    链接阶段    →    可执行文件  
.cpp文件     →    .o目标文件   →    组装过程    →    最终程序  
```  
  
### 链接解决的问题  
  
#### 1. 函数调用地址解析  
```cpp  
// main.cpp  
#include <cmath>  
int main() {  
    double result = sin(3.14);  // sin函数在哪里？编译器不知道！  
    return 0;}  
```  
  
**编译时**：编译器知道有sin函数，但不知道具体地址  
**链接时**：链接器找到数学库中sin函数的地址，填入程序  
  
#### 2. 组合多个编译单元  
```cpp  
// math_utils.cpp  
int add(int a, int b) { return a + b; }  
  
// main.cpp  int add(int a, int b);  // 声明  
int main() {  
    int result = add(5, 3);  // 调用地址待定  
    return 0;}  
```  
  
### 需要链接的库类型  
  
#### 系统级功能库  
```cmake  
target_link_libraries(my_app  
    Threads::Threads    # 线程库  
    m                   # 数学库 (sin, cos, sqrt)    dl                  # 动态链接库  
)  
```  
  
#### 网络库（特殊情况）  
```cpp  
#include <sys/socket.h>  
int sock = socket(AF_INET, SOCK_STREAM, 0);  
```  
  
**为什么socket不需要显式链接？**  
- **Linux/macOS**: socket函数在系统核心库（glibc）中，默认链接  
- **Windows**: 需要显式链接 `wsock32 ws2_32`  
- **类似于**: `printf`, `malloc` 这些基础C函数  
  
#### 第三方库  
```cmake  
find_package(sqlite3 REQUIRED)  
target_link_libraries(my_app sqlite3)  
```  
  
### 不需要链接的库  
  
#### Header-only库  
```cpp  
#include <vector>     // 模板实现在头文件中  
#include <string>     // 大部分在头文件中  
#include <algorithm>  // 算法模板实现  
```  
  
**特点**：实现都在头文件(.h)中，编译时直接包含  
  
### 链接类型  
  
#### 静态链接  
```cmake  
target_link_libraries(my_app -static pthread)  
```  
**结果**：库代码复制到程序中，大文件但独立运行  
  
#### 动态链接  
```cmake  
target_link_libraries(my_app pthread)  
```  
**结果**：运行时加载库，小文件但需要系统有对应库文件  
  
### 跨平台链接示例  
```cmake  
# 完善的跨平台socket处理  
if(WIN32)  
    target_link_libraries(http_server wsock32 ws2_32)elseif(UNIX)  
    # Unix系统socket通常在libc中，不需要额外链接  
    # 但某些系统可能需要  
    find_library(SOCKET_LIBRARY socket)    if(SOCKET_LIBRARY)        target_link_libraries(http_server ${SOCKET_LIBRARY})    endif()endif()  
```  
  
### 语言对比  
  
#### PHP - 运行时链接  
```php  
$pdo = new PDO(...);  // 运行时找PDO扩展  
```  
  
#### Go - 编译时静态链接  
```go  
import "net/http"  // 编译器把标准库代码包含到程序中  
```  
  
#### C++ - 编译时链接  
```cpp  
#include <thread>  // 必须明确指定要链接哪些库  
```  
  
## 构造函数调用机制  
  
### 构造函数选择  
```cpp  
SimpleHttpServer server(8080);  // 调用哪个构造函数？  
```  
  
**匹配规则**：  
- 查找参数类型匹配的构造函数  
- `8080` (int类型) 匹配 `SimpleHttpServer(int p)`  
  
### 构造函数调用过程  
```cpp  
SimpleHttpServer(int p) : port(p), server_fd(-1) {}  
```  
  
**执行步骤**：  
1. **内存分配**：为对象分配内存空间  
2. **成员变量初始化**（按声明顺序，不是初始化列表顺序）：  
   ```cpp  
   int port;        // 第1个声明 → 第1个初始化（值为8080）  
   int server_fd;   // 第2个声明 → 第2个初始化（值为-1）  
   ```3. **构造函数体执行**：这里是空的 `{}`  
  
### 成员初始化顺序  
```cpp  
class SimpleHttpServer {  
private:  
    int port;        // 第1个声明  
    int server_fd;   // 第2个声明  
public:  
    // ⚠️ 初始化顺序由声明顺序决定，不是这里的顺序！  
    SimpleHttpServer(int p) : server_fd(-1), port(p) {}// 实际执行顺序：先port(p)，再server_fd(-1)  
};  
```  
  
### 多构造函数示例  
```cpp  
class SimpleHttpServer {  
public:  
    // 默认构造函数  
    SimpleHttpServer() : port(8080), server_fd(-1) {}    // 带参数构造函数    
    SimpleHttpServer(int p) : port(p), server_fd(-1) {}  
};  
  
// 不同调用方式  
SimpleHttpServer server1;        // 调用默认构造函数  
SimpleHttpServer server2(8080);  // 调用带参数构造函数  
SimpleHttpServer server3{9000};  // 调用带参数构造函数（C++11列表初始化）  
```  
  
### 对象创建后的状态  
```cpp  
SimpleHttpServer server(8080);  
// 创建完成后：  
// server.port = 8080      (从参数p传入)  
// server.server_fd = -1   (初始化为无效socket)  
```  
  
### 语言对比  
  
#### PHP 构造函数  
```php  
class SimpleHttpServer {  
    public function __construct($p) {        $this->port = $p;        $this->server_fd = -1;    }}  
$server = new SimpleHttpServer(8080);  
```  
  
#### Go 结构体初始化  
```go  
type SimpleHttpServer struct {  
    port     int    serverFd int}  
  
func NewSimpleHttpServer(p int) *SimpleHttpServer {  
    return &SimpleHttpServer{port: p, serverFd: -1}}  
```  
  
## 网络结构体初始化  
  
### sockaddr_in 结构体  
```cpp  
sockaddr_in address;  // ⚠️ 声明但未初始化！包含随机垃圾数据  
```  
  
### 安全的初始化方法  
```cpp  
// 方法1：零初始化（推荐）  
sockaddr_in address = {};   // ✅ 所有字段初始化为0  
sockaddr_in address{};      // ✅ C++11风格  
  
// 方法2：memset清零  
sockaddr_in address;  
memset(&address, 0, sizeof(address));  
  
// 方法3：完整初始化  
sockaddr_in address = {  
    .sin_family = AF_INET,    .sin_addr.s_addr = INADDR_ANY,    .sin_port = htons(port)};  
```  
  
### 网络字节序转换  
```cpp  
address.sin_port = htons(8080);  // host to network short  
```  
  
**示例**：  
- 主机字节序（小端）：`0x1f90`  
- 网络字节序（大端）：`0x901f`  
  
### 最终address结构  
```cpp  
// port = 8080时  
address = {  
    sin_family: 2,          // AF_INET (IPv4)    sin_port: 0x901f,       // 8080的网络字节序  
    sin_addr: 0x00000000,   // INADDR_ANY (0.0.0.0)    sin_zero: [0,0,0,0,0,0,0,0]  // 填充字节  
};  
```  
  
**含义**：监听所有网卡接口（0.0.0.0）的8080端口，使用IPv4协议
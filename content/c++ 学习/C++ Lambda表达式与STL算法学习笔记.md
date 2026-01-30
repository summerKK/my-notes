  
## Lambda表达式基础  
  
### 什么是Lambda表达式？  
**Lambda表达式**是C++11引入的匿名函数特性，允许在使用的地方定义简短的函数对象。  
  
### 基本语法  
```cpp  
[捕获列表](参数列表) -> 返回类型 { 函数体 }```  
  
### 简单示例  
```cpp  
// 基本lambda  
auto add = [](int a, int b) { return a + b; };  
int result = add(3, 4);  // result = 7  
  
// 无参数lambda  
auto sayHello = []() { std::cout << "Hello!" << std::endl; };  
sayHello();  
  
// 带返回类型声明  
auto divide = [](double a, double b) -> double {  
    if (b != 0) return a / b;    return 0.0;};  
```  
  
## 捕获列表详解  
  
### 捕获方式  
  
#### 1. 按值捕获  
```cpp  
int x = 10;  
int y = 20;  
  
auto lambda1 = [x](int param) {  
    // x是副本，不能修改外部x  
    std::cout << x + param << std::endl;    // x++;  // ❌ 编译错误！按值捕获的变量是const的  
};  
  
auto lambda2 = [x, y](int param) {  
    return x + y + param;  // 可以读取多个变量  
};  
```  
  
#### 2. 按引用捕获  
```cpp  
int count = 0;  
  
auto increment = [&count]() {  
    count++;  // ✅ 可以修改外部变量  
};  
  
increment();  // count变成1  
increment();  // count变成2  
```  
  
#### 3. 混合捕获  
```cpp  
int local_var = 5;  
int another_var = 10;  
  
auto mixed = [&local_var, another_var](int param) {  
    local_var++;      // ✅ 引用捕获，可修改  
    // another_var++;  // ❌ 按值捕获，不能修改  
    return local_var + another_var + param;};  
```  
  
#### 4. 捕获所有变量  
```cpp  
int a = 1, b = 2, c = 3;  
  
auto capture_all_by_value = [=](int x) {  
    return a + b + c + x;  // 所有外部变量按值捕获  
};  
  
auto capture_all_by_ref = [&](int x) {  
    a++; b++; c++;  // 所有外部变量按引用捕获  
    return a + b + c + x;};  
```  
  
#### 5. this指针捕获  
```cpp  
class MyClass {  
    int member_var = 42;    public:  
    void createLambda() {        // 捕获this指针  
        auto lambda = [this](int x) {            return member_var + x;  // 访问成员变量  
        };        std::cout << lambda(8) << std::endl;  // 输出50  
    }};  
```  
  
### 捕获列表语法总结  
  
| 捕获语法 | 含义 |  
|----------|------|  
| `[]` | 不捕获任何变量 |  
| `[=]` | 按值捕获所有外部变量 |  
| `[&]` | 按引用捕获所有外部变量 |  
| `[x]` | 按值捕获变量x |  
| `[&x]` | 按引用捕获变量x |  
| `[=, &x]` | 按值捕获所有变量，但x按引用捕获 |  
| `[&, x]` | 按引用捕获所有变量，但x按值捕获 |  
| `[this]` | 捕获当前对象的this指针 |  
| `[x, &y, this]` | 混合捕获：x按值，y按引用，this指针 |  
  
## STL算法与Lambda结合  
  
### 1. std::remove_if 算法  
  
#### 基本用法  
```cpp  
std::vector<int> numbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};  
  
// 移除所有偶数  
auto new_end = std::remove_if(numbers.begin(), numbers.end(),  
                             [](int n) { return n % 2 == 0; });  
numbers.erase(new_end, numbers.end());  // 真正删除  
// 结果：{1, 3, 5, 7, 9}  
```  
  
#### 任务管理器中的应用  
```cpp  
size_t removeCompletedTasks() {  
    size_t removed_count = 0;        auto new_end = std::remove_if(tasks.begin(), tasks.end(),  
                                 [&removed_count, this](const std::unique_ptr<Task>& task) {                                     if (task->status == TaskStatus::COMPLETED) {                                         status_count[TaskStatus::COMPLETED]--;  // 更新统计  
                                         removed_count++;                        // 计数  
                                         return true;  // 标记删除  
                                     }                                     return false;     // 保留  
                                 });        tasks.erase(new_end, tasks.end());  
    return removed_count;}  
```  
  
### 2. std::find_if 算法  
  
#### 查找元素  
```cpp  
std::vector<std::string> names = {"Alice", "Bob", "Charlie", "David"};  
  
// 查找以'C'开头的名字  
auto it = std::find_if(names.begin(), names.end(),  
                      [](const std::string& name) {                          return name[0] == 'C';                      });  
if (it != names.end()) {  
    std::cout << "找到: " << *it << std::endl;  // 输出: Charlie  
}  
```  
  
#### 任务查找  
```cpp  
Task* findTask(int id) {  
    auto it = std::find_if(tasks.begin(), tasks.end(),                          [id](const std::unique_ptr<Task>& task) {                              return task->id == id;                          });        return (it != tasks.end()) ? it->get() : nullptr;  
}  
```  
  
### 3. std::sort 算法  
  
#### 自定义排序  
```cpp  
std::vector<std::string> words = {"apple", "pie", "a", "longer"};  
  
// 按长度排序  
std::sort(words.begin(), words.end(),  
         [](const std::string& a, const std::string& b) {             return a.length() < b.length();         });// 结果：{"a", "pie", "apple", "longer"}  
```  
  
#### 任务按优先级排序  
```cpp  
void sortTasksByPriority() {  
    std::sort(tasks.begin(), tasks.end(),             [](const std::unique_ptr<Task>& a, const std::unique_ptr<Task>& b) {                 return static_cast<int>(a->priority) > static_cast<int>(b->priority);             });}  
```  
  
### 4. std::count_if 算法  
  
#### 条件计数  
```cpp  
std::vector<int> numbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};  
  
// 统计偶数个数  
size_t even_count = std::count_if(numbers.begin(), numbers.end(),  
                                 [](int n) { return n % 2 == 0; });  
std::cout << "偶数个数: " << even_count << std::endl;  // 输出: 5  
```  
  
#### 统计特定状态的任务  
```cpp  
size_t getCompletedTaskCount() const {  
    return std::count_if(tasks.begin(), tasks.end(),                        [](const std::unique_ptr<Task>& task) {                            return task->status == TaskStatus::COMPLETED;                        });}  
```  
  
### 5. std::for_each 算法  
  
#### 对每个元素执行操作  
```cpp  
std::vector<int> numbers = {1, 2, 3, 4, 5};  
  
// 打印所有元素  
std::for_each(numbers.begin(), numbers.end(),  
             [](int n) {                 std::cout << n << " ";             });  
// 修改所有元素  
std::for_each(numbers.begin(), numbers.end(),  
             [](int& n) {  // 注意：引用参数  
                 n *= 2;             });```  
  
## remove-erase惯用法  
  
### 为什么需要两步操作？  
  
#### remove_if 的工作原理  
```cpp  
// 原始容器：[1, 2, 3, 4, 5, 6]  
// 移除偶数后：[1, 3, 5, 4, 5, 6]  <- 后面是"垃圾"数据  
//                    ↑  
//               new_end指向这里  
  
// remove_if只是移动元素，不改变容器大小  
// 需要erase来真正删除  
```  
  
#### 完整的删除过程  
```cpp  
// 第1步：标记和移动  
auto new_end = std::remove_if(vec.begin(), vec.end(), condition);  
  
// 第2步：真正删除  
vec.erase(new_end, vec.end());  
  
// 可以合并为一行  
vec.erase(std::remove_if(vec.begin(), vec.end(), condition), vec.end());  
```  
  
### 性能优势  
```cpp  
// ✅ 高效：remove_if + erase  
// 只移动一次，批量删除  
vec.erase(std::remove_if(vec.begin(), vec.end(), condition), vec.end());  
  
// ❌ 低效：逐个erase  
// 每次删除都要移动后续元素  
for (auto it = vec.begin(); it != vec.end(); ) {  
    if (condition(*it)) {        it = vec.erase(it);  // 多次移动  
    } else {        ++it;    }}  
```  
  
## 函数式编程风格  
  
### 声明式 vs 命令式  
  
#### 声明式风格（推荐）  
```cpp  
// 声明式：说明"做什么"  
auto completed_tasks = std::count_if(tasks.begin(), tasks.end(),  
                                   [](const auto& task) {                                       return task->status == TaskStatus::COMPLETED;                                   });  
// 筛选高优先级任务  
std::vector<Task*> high_priority_tasks;  
std::copy_if(tasks.begin(), tasks.end(), std::back_inserter(high_priority_tasks),  
            [](const auto& task) {                return task->priority == TaskPriority::HIGH;            });```  
  
#### 命令式风格  
```cpp  
// 命令式：说明"怎么做"  
size_t completed_tasks = 0;  
for (const auto& task : tasks) {  
    if (task->status == TaskStatus::COMPLETED) {        completed_tasks++;    }}  
  
std::vector<Task*> high_priority_tasks;  
for (const auto& task : tasks) {  
    if (task->priority == TaskPriority::HIGH) {        high_priority_tasks.push_back(task.get());    }}  
```  
  
## 语言对比  
  
### PHP - 匿名函数  
```php  
$numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];  
  
// 过滤偶数  
$odds = array_filter($numbers, function($n) {  
    return $n % 2 != 0;});  
  
// 使用外部变量  
$threshold = 5;  
$large_numbers = array_filter($numbers, function($n) use ($threshold) {  
    return $n > $threshold;});  
```  
  
### JavaScript - 箭头函数  
```javascript  
const numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];  
  
// 过滤偶数  
const odds = numbers.filter(n => n % 2 !== 0);  
  
// 查找元素  
const found = numbers.find(n => n > 5);  
  
// 排序  
const sorted = numbers.sort((a, b) => b - a);  
```  
  
### Go - 匿名函数  
```go  
numbers := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}  
  
// Go没有内置的filter，需要手动实现  
var odds []int  
for _, n := range numbers {  
    if n%2 != 0 {        odds = append(odds, n)    }}  
  
// 使用匿名函数排序  
sort.Slice(numbers, func(i, j int) bool {  
    return numbers[i] < numbers[j]})  
```  
  
### C++ - Lambda表达式  
```cpp  
std::vector<int> numbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};  
  
// 过滤偶数  
numbers.erase(std::remove_if(numbers.begin(), numbers.end(),  
                            [](int n) { return n % 2 == 0; }),              numbers.end());  
// 查找元素  
auto it = std::find_if(numbers.begin(), numbers.end(),  
                      [](int n) { return n > 5; });  
// 排序  
std::sort(numbers.begin(), numbers.end(),  
         [](int a, int b) { return a > b; });```  
  
## 高级Lambda特性  
  
### 1. mutable关键字  
```cpp  
int x = 0;  
  
auto lambda = [x]() mutable {  
    x++;  // ✅ mutable允许修改按值捕获的变量  
    return x;};  
  
std::cout << lambda() << std::endl;  // 输出: 1  
std::cout << lambda() << std::endl;  // 输出: 2  
std::cout << x << std::endl;         // 输出: 0 (外部x不变)  
```  
  
### 2. 泛型Lambda（C++14）  
```cpp  
auto generic_lambda = [](auto a, auto b) {  
    return a + b;};  
  
std::cout << generic_lambda(1, 2) << std::endl;           // int  
std::cout << generic_lambda(1.5, 2.5) << std::endl;      // double  
std::cout << generic_lambda("Hello", "World") << std::endl; // string  
```  
  
### 3. 初始化捕获（C++14）  
```cpp  
auto lambda = [counter = 0](int x) mutable {  
    return ++counter + x;};  
  
std::cout << lambda(10) << std::endl;  // 输出: 11  
std::cout << lambda(10) << std::endl;  // 输出: 12  
```  
  
## 实际应用场景  
  
### 1. 配合标准算法  
```cpp  
class TaskManager {  
public:  
    // 获取特定状态的任务数量  
    size_t getTaskCountByStatus(TaskStatus status) const {        return std::count_if(tasks.begin(), tasks.end(),                            [status](const std::unique_ptr<Task>& task) {                                return task->status == status;                            });    }    // 查找最高优先级的任务  
    Task* getHighestPriorityTask() const {        auto it = std::max_element(tasks.begin(), tasks.end(),                                  [](const std::unique_ptr<Task>& a,                                     const std::unique_ptr<Task>& b) {  
                                      return static_cast<int>(a->priority) <                                             static_cast<int>(b->priority);  
                                  });                return (it != tasks.end()) ? it->get() : nullptr;  
    }    // 按多个条件筛选任务  
    std::vector<Task*> getTasksByFilter(TaskStatus status, TaskPriority min_priority) const {        std::vector<Task*> result;                std::copy_if(tasks.begin(), tasks.end(), std::back_inserter(result),  
                    [status, min_priority](const std::unique_ptr<Task>& task) {                        return task->status == status &&                               task->priority >= min_priority;  
                    });                return result;  
    }};  
```  
  
### 2. 事件处理  
```cpp  
class EventHandler {  
    std::vector<std::function<void(int)>> callbacks;    public:  
    void addCallback(std::function<void(int)> callback) {        callbacks.push_back(callback);    }        void triggerEvent(int value) {  
        std::for_each(callbacks.begin(), callbacks.end(),                     [value](const auto& callback) {                         callback(value);                     });    }};  
  
// 使用  
EventHandler handler;  
handler.addCallback([](int x) { std::cout << "Callback 1: " << x << std::endl; });  
handler.addCallback([](int x) { std::cout << "Callback 2: " << x * 2 << std::endl; });  
```  
  
## 最佳实践  
  
### 1. 选择合适的捕获方式  
```cpp  
// ✅ 需要修改外部变量 - 引用捕获  
[&count](/*...*/) { count++; }  
  
// ✅ 只读小对象 - 值捕获  
[max_size](/*...*/) { return size < max_size; }  
  
// ✅ 只读大对象 - const引用捕获（C++14）  
[&max_string = large_string](/*...*/) { return str.length() < max_string.length(); }  
  
// ✅ 访问成员 - this捕获  
[this](/*...*/) { return member_var > 0; }  
```  
  
### 2. 避免悬空引用  
```cpp  
std::function<int()> createBadLambda() {  
    int local = 42;    // ❌ 危险！lambda可能比local存活更久  
    return [&local]() { return local; };}  
  
std::function<int()> createGoodLambda() {  
    int local = 42;    // ✅ 安全！按值捕获  
    return [local]() { return local; };}  
```  
  
### 3. 保持简洁  
```cpp  
// ✅ 简洁的lambda  
auto is_even = [](int n) { return n % 2 == 0; };  
  
// ❌ 过于复杂的lambda，应该提取为函数  
auto complex_lambda = [](const auto& task) {  
    // 20行复杂逻辑...  
    // 应该提取为独立函数  
};  
```  
  
### 4. 使用auto推导类型  
```cpp  
// ✅ 使用auto  
auto lambda = [](int x) { return x * 2; };  
  
// ❌ 手动写类型（繁琐且容易出错）  
std::function<int(int)> lambda2 = [](int x) { return x * 2; };  
```  
  
**总结**：Lambda表达式是现代C++的重要特性，它让函数式编程变得简洁优雅。配合STL算法使用，可以写出既高效又易读的代码，这是C++相比传统命令式编程的重大进步！
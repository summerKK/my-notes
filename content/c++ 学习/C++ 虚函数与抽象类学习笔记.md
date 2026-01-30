  
## 虚函数基础  
  
### 什么是虚函数？  
**虚函数**是C++实现多态性的核心机制，允许子类重新定义父类的函数，并在运行时根据对象的实际类型调用正确的版本。  
  
### 虚函数 vs 普通函数  
  
#### 普通函数（编译时确定）  
```cpp  
class Task {  
public:  
    void showInfo() {  // 普通函数  
        std::cout << "这是基础任务" << std::endl;  
    }};  
  
class DevTask : public Task {  
public:  
    void showInfo() {  // 重新定义，但不是重写  
        std::cout << "这是开发任务" << std::endl;  
    }};  
  
Task* task = new DevTask();  
task->showInfo();  // 输出："这是基础任务"（调用父类版本）  
```  
  
#### 虚函数（运行时确定）  
```cpp  
class Task {  
public:  
    virtual void showInfo() {  // ✅ 虚函数  
        std::cout << "这是基础任务" << std::endl;  
    }};  
  
class DevTask : public Task {  
public:  
    void showInfo() override {  // ✅ 重写虚函数  
        std::cout << "这是开发任务" << std::endl;  
    }};  
  
Task* task = new DevTask();  
task->showInfo();  // 输出："这是开发任务"（调用子类版本）  
```  
  
## 虚析构函数的重要性  
  
### 为什么需要虚析构函数？  
  
#### 没有虚析构函数的问题  
```cpp  
class Task {  
public:  
    ~Task() {  // ❌ 普通析构函数  
        std::cout << "Task 析构" << std::endl;  
    }};  
  
class DevTask : public Task {  
    std::string* data;  // 动态分配的资源  
public:  
    DevTask() { data = new std::string("重要数据"); }  
    ~DevTask() {  // ❌ 不会被调用！  
        delete data;  // 内存泄漏！  
        std::cout << "DevTask 析构" << std::endl;  
    }};  
  
// 危险的使用方式  
Task* task = new DevTask();  // 指向子类的父类指针  
delete task;  // ❌ 只调用Task析构，不调用DevTask析构！  
// 结果：内存泄漏！data没有被释放  
```  
  
#### 虚析构函数的解决方案  
```cpp  
class Task {  
public:  
    virtual ~Task() = default;  // ✅ 虚析构函数  
};  
  
class DevTask : public Task {  
    std::string* data;public:  
    DevTask() { data = new std::string("重要数据"); }  
    ~DevTask() {  // ✅ 会被正确调用  
        delete data;  // 正确释放内存  
        std::cout << "DevTask 析构" << std::endl;  
    }};  
  
// 安全的使用方式  
Task* task = new DevTask();  
delete task;  // ✅ 先调用DevTask析构，再调用Task析构  
// 结果：内存正确释放  
```  
  
### = default 的含义  
```cpp  
virtual ~Task() = default;  
```  
  
**= default** 的作用：  
- 使用编译器生成的默认实现  
- 相当于：`virtual ~Task() {}`  
- 明确表达意图：需要默认行为，但要虚函数特性  
  
## const 成员函数  
  
### const 成员函数的含义  
```cpp  
virtual std::string getInfo() const {  // const在这里！  
    return "Task #" + std::to_string(id) + ": " + title;}  
```  
  
**承诺这个函数不会修改对象的任何成员变量**  
  
### const 函数的限制  
```cpp  
class Task {  
    int id;    std::string title;public:  
    // ✅ const函数 - 只能读取，不能修改  
    std::string getInfo() const {        // ✅ 可以读取成员变量  
        return "Task #" + std::to_string(id) + ": " + title;        // ❌ 编译错误！不能修改成员变量  
        // id = 100;        // 错误！  
        // title = "新标题";  // 错误！  
    }    // 非const函数 - 可以修改  
    void setTitle(const std::string& new_title) {        title = new_title;  // ✅ 可以修改  
    }};  
```  
  
### const 对象的限制  
```cpp  
const Task task("学习C++");  
  
task.getInfo();     // ✅ 可以调用const函数  
task.setTitle("新"); // ❌ 编译错误！const对象不能调用非const函数  
```  
  
### const 函数重载  
```cpp  
class Task {  
public:  
    // 非const版本  
    std::string& getTitle() {        std::cout << "调用非const版本" << std::endl;  
        return title;    }        // const版本  
    const std::string& getTitle() const {        std::cout << "调用const版本" << std::endl;  
        return title;    }};  
  
Task task;  
const Task const_task;  
  
task.getTitle();       // 调用非const版本  
const_task.getTitle(); // 调用const版本  
```  
  
## 纯虚函数与抽象类  
  
### 纯虚函数语法  
```cpp  
virtual double calculateEffort() const = 0;  // 纯虚函数  
```  
  
**`= 0`** 的含义：  
- 这是一个**纯虚函数**  
- 没有实现，子类**必须**实现  
- 相当于PHP的`abstract`方法  
  
### C++ 抽象类定义  
**包含至少一个纯虚函数的类就是抽象类**  
  
```cpp  
class Task {  // 抽象类 - 因为有纯虚函数  
public:  
    virtual std::string getInfo() const = 0;           // 纯虚函数  
    virtual double calculateEffort() const = 0;        // 纯虚函数  
    virtual ~Task() = default;                         // 虚析构函数  
};  
  
// ❌ 编译错误！不能实例化抽象类  
// Task task;  // 错误：不能创建抽象类的对象  
```  
  
### 实现抽象类的子类  
```cpp  
class DevTask : public Task {  
private:  
    int estimated_hours;    public:  
    // 必须实现所有纯虚函数  
    double calculateEffort() const override {        return estimated_hours;    }        std::string getInfo() const override {  
        return "开发任务: " + title;  
    }};  
  
DevTask task;  // ✅ 可以实例化具体类  
```  
  
## 语言对比  
  
### PHP 抽象类  
```php  
abstract class Task {  // 显式abstract关键字  
    protected $id;    protected $title;    // 具体方法  
    public function getId() {        return $this->id;    }    // 抽象方法 - 子类必须实现  
    abstract public function calculateEffort();    abstract public function getInfo();}  
  
class DevTask extends Task {  
    private $estimated_hours;    // 必须实现所有抽象方法  
    public function calculateEffort() {        return $this->estimated_hours;    }        public function getInfo() {  
        return "开发任务: " . $this->title;  
    }}  
  
// $task = new Task();     // ❌ 错误：不能实例化抽象类  
$task = new DevTask();     // ✅ 可以实例化具体类  
```  
  
### C++ 抽象类  
```cpp  
class Task {  // 隐式抽象类（因为有纯虚函数）  
protected:  
    int id;    std::string title;    public:  
    // 具体方法  
    int getId() const { return id; }    // 纯虚函数 - 子类必须实现  
    virtual double calculateEffort() const = 0;    virtual std::string getInfo() const = 0;    virtual ~Task() = default;};  
  
class DevTask : public Task {  
private:  
    int estimated_hours;    public:  
    // 必须实现所有纯虚函数  
    double calculateEffort() const override {        return estimated_hours;    }        std::string getInfo() const override {  
        return "开发任务: " + title;  
    }};  
  
// Task task;       // ❌ 错误：不能实例化抽象类  
DevTask task;       // ✅ 可以实例化具体类  
```  
  
### Go 接口对比  
```go  
// Go接口 - 隐式实现  
type Drawable interface {  
    Draw()    Resize(width, height int)}  
  
// 任何实现了这些方法的类型都自动实现了接口  
type Circle struct {  
    radius float64}  
  
func (c Circle) Draw() { /* 实现 */ }func (c Circle) Resize(width, height int) { /* 实现 */ }// Circle 自动实现了 Drawable 接口  
```  
  
## 多态性实际应用  
  
### 抽象基类设计  
```cpp  
class Task {  // 抽象基类  
public:  
    // 具体实现 - 所有子类都需要的通用功能  
    Task(const std::string& title) : title(title) {}    std::string getTitle() const { return title; }    // 纯虚函数 - 每种任务类型都有不同的实现  
    virtual double calculateEffort() const = 0;  // 工作量计算方式不同  
    virtual std::string getInfo() const = 0;     // 信息展示方式不同  
        virtual ~Task() = default;  
    protected:  
    std::string title;};  
```  
  
### 多态容器应用  
```cpp  
// 多态容器 - 存储不同类型的任务  
std::vector<std::unique_ptr<Task>> tasks;  
  
// 添加不同的具体类型  
tasks.push_back(std::make_unique<DevTask>("开发功能", "C++", 8));  
tasks.push_back(std::make_unique<StudyTask>("学习C++", "编程", 50));  
  
// 多态调用 - 运行时确定调用哪个版本  
for (const auto& task : tasks) {  
    std::cout << task->getInfo() << std::endl;        // 调用各自的实现  
    std::cout << task->calculateEffort() << std::endl; // 调用各自的计算方式  
}  
```  
  
## 抽象类 vs 接口  
  
### C++ 中的"接口"类  
```cpp  
// 纯接口类 - 只有纯虚函数  
class Drawable {  
public:  
    virtual void draw() const = 0;    virtual void resize(int width, int height) = 0;    virtual ~Drawable() = default;};  
  
// 抽象类 - 有具体实现 + 纯虚函数  
class Shape : public Drawable {  
protected:  
    int x, y;  // 具体数据  
    public:  
    Shape(int x, int y) : x(x), y(y) {}  // 具体构造函数  
    void moveTo(int new_x, int new_y) {  // 具体方法  
        x = new_x; y = new_y;    }    virtual double area() const = 0;  // 纯虚函数  
    virtual void draw() const = 0;    // 继承的纯虚函数  
};  
```  
  
## 最佳实践  
  
### 1. 虚析构函数规则  
```cpp  
class Base {  
public:  
    // ✅ 如果类被继承，总是使用虚析构函数  
    virtual ~Base() = default;};  
```  
  
### 2. const 正确性  
```cpp  
class Task {  
public:  
    // ✅ 只读操作都加const  
    int getId() const { return id; }    std::string getTitle() const { return title; }    TaskStatus getStatus() const { return status; }    // 只有修改操作不加const  
    void setStatus(TaskStatus status) { this->status = status; }};  
```  
  
### 3. override 关键字  
```cpp  
class DevTask : public Task {  
public:  
    // ✅ 使用override确保正确重写  
    std::string getInfo() const override {        return "开发任务";   
    }  
        double calculateEffort() const override {   
        return estimated_hours;   
    }  
};  
```  
  
## 关键概念对比表  
  
| 特性 | PHP abstract | C++ 纯虚函数 | Go interface |  
|------|-------------|-------------|-------------|  
| 关键字 | `abstract` | `= 0` | `interface` |  
| 声明方式 | 显式abstract类 | 隐式抽象类 | 显式接口 |  
| 实例化 | 不能实例化 | 不能实例化 | 接口类型变量 |  
| 实现要求 | 必须实现abstract方法 | 必须实现纯虚函数 | 隐式实现 |  
| 多态支持 | 支持 | 支持 | 支持 |  
| 具体实现 | 可以有具体方法 | 可以有具体方法 | 只有方法签名 |  
  
**总结**：C++通过虚函数、纯虚函数和抽象类实现强大的多态性机制，虽然语法与PHP不同，但概念和作用非常相似！
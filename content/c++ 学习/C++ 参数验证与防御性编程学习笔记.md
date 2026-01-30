
## 核心问题
在任务管理器项目中遇到的思考：
```cpp
void addTask(std::unique_ptr<TaskImitation> task) {
    if (!task) {
        throw std::invalid_argument("任务不能为空");
    }
    // ...
}
```

**问题**：既然实际调用中task不可能为null，为什么还要验证？每个函数都验证参数会不会很累？

## 防御性编程的价值

### 1. 代码演进保护
**当前调用**：
```cpp
auto task = std::make_unique<DevTaskImitation>(...);  // 总是成功
manager.addTask(std::move(task));  // 不可能为null
```

**未来可能的调用**：
```cpp
std::unique_ptr<TaskImitation> task;
if (complexCondition()) {
    task = createComplexTask();  // 可能失败返回nullptr
}
manager.addTask(std::move(task));  // 这时就需要检查了！
```

### 2. 接口契约明确性
参数检查相当于**活文档**：
- 明确告诉调用者："我不接受空指针"
- 违反契约立即抛出清晰异常
- 比隐式崩溃更容易调试

### 3. 错误早发现原则
**不检查的后果**：
```
传入nullptr → 后续某处访问 → 段错误崩溃 → 调试困难
```

**检查的好处**：
```
传入nullptr → 立即抛异常 → 清晰错误信息 → 快速定位
```

## 参数验证的工程平衡策略

### 策略1：边界检查原则
```cpp
class TaskManager {
public:
    // 公共接口：必须检查外部输入
    void addTask(std::unique_ptr<TaskImitation> task) {
        if (!task) throw std::invalid_argument("任务不能为空"); // ✅ 必要
    }
    
private:
    // 内部函数：假设参数已验证，避免重复检查
    void internalHelper(TaskImitation* task) {
        // 不重复检查，提高性能 ✅
        processTask(task);
    }
};
```

### 策略2：风险评估原则
根据错误后果决定是否检查：

**高风险（必须检查）**：
```cpp
void accessArray(std::vector<int>& arr, size_t index) {
    if (index >= arr.size()) throw std::out_of_range("索引越界"); // ✅
}
```

**中风险（选择性检查）**：
```cpp
void setPriority(int priority) {
    if (priority < 1 || priority > 4) {
        throw std::invalid_argument("优先级范围1-4"); // 根据项目决定
    }
}
```

**低风险（通常不检查）**：
```cpp
void optimizePerformance(int hint) {
    // 性能提示参数，错误也不会崩溃，通常不检查
}
```

### 策略3：类型系统减少检查
```cpp
// 方案A：可能为空，需要检查
void processTask(std::unique_ptr<TaskImitation> task);

// 方案B：引用不会为空，无需检查  
void processTask(const TaskImitation& task);  // ✅ 更安全的设计

// 方案C：使用optional明确表达可选性
void processTask(std::optional<std::unique_ptr<TaskImitation>> task);
```

## 实际开发中的平衡点

### 极端对比
```cpp
// ❌ 过度防御 - 开发效率低
void addTask(std::unique_ptr<TaskImitation> task) {
    if (!task) throw std::invalid_argument("task为空");
    if (task->title.empty()) throw std::invalid_argument("标题为空");
    if (task->description.length() > 1000) throw std::invalid_argument("描述过长");
    if (task->priority < 1 || task->priority > 4) throw std::invalid_argument("优先级无效");
    // ... 检查100个条件，写代码累死
}

// ❌ 完全不防御 - 调试困难
void addTask(std::unique_ptr<TaskImitation> task) {
    tasks.push_back(std::move(task)); // 祈祷一切正常，出错难找原因
}

// ✅ 合理平衡 - 关键检查 + 清晰接口
void addTask(std::unique_ptr<TaskImitation> task) {
    if (!task) throw std::invalid_argument("任务不能为空");
    // 其他业务逻辑检查根据项目需要决定
    tasks.push_back(std::move(task));
}
```

## 最佳实践建议

### 1. 分层检查策略
- **API边界**：严格验证所有外部输入
- **模块内部**：假设输入已验证，减少冗余检查
- **性能关键路径**：最小化检查，依赖类型安全

### 2. 错误处理一致性
```cpp
// 统一异常类型和错误信息格式
if (!task) throw std::invalid_argument("任务不能为空");
if (id <= 0) throw std::invalid_argument("任务ID必须为正数");
```

### 3. 文档化验证规则
```cpp
/**
 * 添加任务到管理器
 * @param task 非空的任务智能指针
 * @throws std::invalid_argument task为空时抛出
 */
void addTask(std::unique_ptr<TaskImitation> task);
```

## 核心原则总结

> **"每个函数都验证确实很累，但关键边界必须守住"**

- **外部接口**：严格验证，保护系统
- **内部调用**：信任假设，提高效率  
- **风险导向**：高风险必查，低风险可选
- **类型安全**：用设计减少运行时检查需要

防御性编程是**正确性**与**开发效率**之间的工程平衡艺术。

---
*学习时间：2025年9月3日*
*项目：任务管理器 - 参数验证思考*
*关键领悟：工程就是在正确性和效率间找平衡* ⚖️
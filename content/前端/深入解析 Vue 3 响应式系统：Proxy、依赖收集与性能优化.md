---
title: 深入解析 Vue 3 响应式系统
subtitle: Proxy、依赖收集与性能优化
date: 2026-01-14
tags:
  - 前端/Vue
  - JavaScript/Proxy
  - 响应式系统
  - 性能优化
  - 源码分析
aliases:
  - Vue 3 Reactivity
  - Vue 响应式原理
status: 完成
difficulty: 高级
reading-time: 30分钟
---

# 深入解析 Vue 3 响应式系统

> [!abstract] 文章摘要
> 本文深入剖析 Vue 3 响应式系统的核心实现原理，包括 Proxy API 的应用、依赖收集机制、effect 系统以及性能优化策略。适合有一定 Vue 经验的开发者深入理解框架底层机制。

## 目录

1. [[#引言：从 Vue 2 到 Vue 3 的响应式演进]]
2. [[#Proxy vs Object.defineProperty]]
3. [[#响应式系统核心实现]]
4. [[#依赖收集机制深度解析]]
5. [[#ref vs reactive：设计权衡]]
6. [[#性能优化策略]]
7. [[#实践应用与最佳实践]]
8. [[#总结]]

---

## 引言：从 Vue 2 到 Vue 3 的响应式演进

### Vue 2 的局限性

> [!warning] Vue 2 的限制
> Vue 2 使用 `Object.defineProperty` 实现响应式，存在以下限制：
> - **无法检测对象属性的添加和删除**：需要使用 `Vue.set` 和 `Vue.delete`
> - **无法检测数组索引和长度的变化**：需要重写数组方法
> - **性能开销**：需要递归遍历对象的所有属性
> - **初始化成本高**：在组件创建时就要处理所有数据

### Vue 3 的革新

> [!success] Vue 3 的改进
> Vue 3 采用 ES6 Proxy API，带来了根本性的改进：
> - ✅ **完整的对象拦截**：可以拦截属性的添加、删除、枚举等操作
> - ✅ **原生数组支持**：无需特殊处理数组操作
> - ✅ **惰性响应式**：只在访问时才进行响应式转换
> - ✅ **更好的性能**：减少了初始化开销和内存占用

---

## Proxy vs Object.defineProperty

### 技术对比

| 特性 | Object.defineProperty | Proxy |
|------|----------------------|-------|
| 拦截范围 | 单个属性 | 整个对象 |
| 新增属性 | ❌ 无法检测 | ✅ 自动响应 |
| 删除属性 | ❌ 无法检测 | ✅ 自动响应 |
| 数组操作 | ❌ 需要特殊处理 | ✅ 原生支持 |
| 性能 | 初始化慢，运行时快 | 初始化快，运行时略慢 |
| 浏览器支持 | IE9+ | 现代浏览器（不可 polyfill） |

### Proxy 的核心优势

```javascript
// Vue 2: 无法检测新增属性
const obj = { count: 0 }
// 需要使用 Vue.set(obj, 'newProp', 1)

// Vue 3: 自动检测
const state = reactive({ count: 0 })
state.newProp = 1  // ✅ 自动响应式
```

> [!info] Proxy 可以拦截的操作
> - `get`：属性读取
> - `set`：属性设置
> - `has`：`in` 操作符
> - `deleteProperty`：`delete` 操作符
> - `ownKeys`：`Object.keys()`、`for...in`
> - 等 13 种操作

---

## 响应式系统核心实现

### reactive() 的实现原理

`reactive()` 使用 Proxy 创建响应式对象：

```javascript
function reactive(obj) {
  return new Proxy(obj, {
    get(target, key, receiver) {
      // 依赖收集
      track(target, key)

      // 返回属性值
      const result = Reflect.get(target, key, receiver)

      // 如果是对象，递归转换为响应式（惰性）
      if (isObject(result)) {
        return reactive(result)
      }

      return result
    },

    set(target, key, value, receiver) {
      // 获取旧值
      const oldValue = target[key]

      // 设置新值
      const result = Reflect.set(target, key, value, receiver)

      // 如果值发生变化，触发更新
      if (oldValue !== value) {
        trigger(target, key)
      }

      return result
    },

    deleteProperty(target, key) {
      // 检查属性是否存在
      const hadKey = hasOwn(target, key)

      // 删除属性
      const result = Reflect.deleteProperty(target, key)

      // 如果删除成功且属性存在，触发更新
      if (result && hadKey) {
        trigger(target, key)
      }

      return result
    }
  })
}
```

> [!tip] 关键设计点
> 1. **使用 Reflect**：确保正确的 `this` 绑定和返回值
> 2. **惰性转换**：只在访问嵌套对象时才转换为响应式
> 3. **值变化检测**：只在值真正改变时才触发更新

### ref() 的实现原理

`ref()` 使用 getter/setter 包装基本类型值：

```javascript
function ref(value) {
  // 如果已经是 ref，直接返回
  if (isRef(value)) {
    return value
  }

  return new RefImpl(value)
}

class RefImpl {
  private _value
  private _rawValue
  public dep = undefined  // 依赖集合
  public readonly __v_isRef = true

  constructor(value) {
    // 保存原始值（用于比较）
    this._rawValue = toRaw(value)
    // 如果是对象，转换为 reactive
    this._value = toReactive(value)
  }

  get value() {
    // 依赖收集
    trackRefValue(this)
    return this._value
  }

  set value(newVal) {
    // 使用原始值比较（避免响应式对象的比较问题）
    newVal = toRaw(newVal)

    if (hasChanged(newVal, this._rawValue)) {
      this._rawValue = newVal
      this._value = toReactive(newVal)
      // 触发更新
      triggerRefValue(this)
    }
  }
}

// 辅助函数
function toReactive(value) {
  return isObject(value) ? reactive(value) : value
}
```

> [!note] ref 的设计考量
> 1. **统一接口**：通过 `.value` 提供统一的访问方式
> 2. **自动解包**：在模板和 reactive 对象中自动解包
> 3. **对象支持**：如果值是对象，内部使用 `reactive()` 处理

---

## 依赖收集机制深度解析

### 核心数据结构

Vue 3 使用三层嵌套的数据结构存储依赖关系：

```typescript
// 全局依赖映射
type TargetMap = WeakMap<any, DepsMap>

// 对象的依赖映射
type DepsMap = Map<any, Dep>

// 属性的依赖集合
type Dep = Set<ReactiveEffect>

// 全局存储
const targetMap: TargetMap = new WeakMap()
```

**数据结构示意**：

```
WeakMap {
  target1 => Map {
    key1 => Set { effect1, effect2 },
    key2 => Set { effect3 }
  },
  target2 => Map {
    key1 => Set { effect1 }
  }
}
```

> [!question] 为什么使用 WeakMap？
> - 允许目标对象被垃圾回收
> - 避免内存泄漏
> - 不需要手动清理依赖

### track() - 依赖收集

```javascript
// 当前正在执行的 effect
let activeEffect = undefined

function track(target, key) {
  // 如果没有活动的 effect，不需要收集依赖
  if (!activeEffect) {
    return
  }

  // 获取 target 的依赖映射
  let depsMap = targetMap.get(target)
  if (!depsMap) {
    targetMap.set(target, (depsMap = new Map()))
  }

  // 获取 key 的依赖集合
  let dep = depsMap.get(key)
  if (!dep) {
    depsMap.set(key, (dep = new Set()))
  }

  // 将当前 effect 添加到依赖集合
  if (!dep.has(activeEffect)) {
    dep.add(activeEffect)
    // 双向记录：effect 也记录它依赖的 dep
    activeEffect.deps.push(dep)
  }
}
```

### trigger() - 触发更新

```javascript
function trigger(target, key) {
  // 获取 target 的依赖映射
  const depsMap = targetMap.get(target)
  if (!depsMap) {
    // 没有依赖，直接返回
    return
  }

  // 获取需要触发的 effects
  const effects = new Set()

  // 添加与 key 相关的 effects
  const dep = depsMap.get(key)
  if (dep) {
    dep.forEach(effect => {
      // 避免无限循环：不触发当前正在执行的 effect
      if (effect !== activeEffect) {
        effects.add(effect)
      }
    })
  }

  // 执行所有 effects
  effects.forEach(effect => {
    if (effect.options.scheduler) {
      // 如果有调度器，使用调度器执行
      effect.options.scheduler(effect)
    } else {
      // 否则直接执行
      effect()
    }
  })
}
```

### ReactiveEffect - Effect 系统

```javascript
class ReactiveEffect {
  active = true
  deps = []  // 该 effect 依赖的所有 dep

  constructor(fn, scheduler = null) {
    this.fn = fn
    this.scheduler = scheduler
  }

  run() {
    // 如果 effect 已被停止，只执行函数，不收集依赖
    if (!this.active) {
      return this.fn()
    }

    // 清理旧的依赖
    cleanupEffect(this)

    // 设置为当前活动的 effect
    const parent = activeEffect
    activeEffect = this

    try {
      // 执行函数，期间会触发 track() 收集依赖
      return this.fn()
    } finally {
      // 恢复之前的 activeEffect
      activeEffect = parent
    }
  }

  stop() {
    if (this.active) {
      cleanupEffect(this)
      this.active = false
    }
  }
}

// 清理 effect 的所有依赖
function cleanupEffect(effect) {
  const { deps } = effect
  if (deps.length) {
    for (let i = 0; i < deps.length; i++) {
      deps[i].delete(effect)
    }
    deps.length = 0
  }
}
```

### 完整的响应式流程

```javascript
// 1. 创建响应式对象
const state = reactive({ count: 0 })

// 2. 创建 effect（例如组件的渲染函数）
const effect = new ReactiveEffect(() => {
  console.log('count:', state.count)  // 触发 get，调用 track()
})

// 3. 执行 effect
effect.run()
// 输出: count: 0
// 此时 state.count 的依赖集合中包含了这个 effect

// 4. 修改数据
state.count++  // 触发 set，调用 trigger()

// 5. trigger() 执行所有依赖的 effects
// 输出: count: 1
```

**响应式系统完整流程**：

> [!success] 🎬 **阶段 1：初始化**
> 1. **创建响应式对象** → `reactive(obj)` 返回 `new Proxy`
> 2. **创建 effect** → `new ReactiveEffect(fn)`
> 3. **执行 effect** → `effect.run()` 设置 `activeEffect`

> [!warning] 📥 **阶段 2：依赖收集**
> 4. **访问属性 (getter)** → `state.count` 触发 `Proxy.get`
> 5. **收集依赖** → `track(target, 'count')` 记录到 `targetMap`

> [!tip] 📤 **阶段 3：触发更新**
> 6. **修改属性 (setter)** → `state.count = 1` 触发 `Proxy.set`
> 7. **触发更新** → `trigger(target, 'count')` 查找依赖

> [!success] ⚡ **阶段 4：执行响应**
> 8. **执行 effects** → 遍历 `deps` 执行所有相关 `effects`，完成响应式更新

**流程总结**：`创建 Proxy` → `执行 effect` → `getter 收集依赖` → `setter 触发更新` → `执行 effects`

---

## ref vs reactive：设计权衡

### 使用场景对比

```javascript
// ✅ reactive: 适合对象
const state = reactive({
  user: { name: 'Alice', age: 25 },
  settings: { theme: 'dark' }
})

// ✅ ref: 适合基本类型
const count = ref(0)
const message = ref('Hello')

// ⚠️ reactive 的限制
let state = reactive({ count: 0 })
state = reactive({ count: 1 })  // ❌ 失去响应式！

// ✅ ref 可以重新赋值
let count = ref(0)
count.value = 1  // ✅ 保持响应式
```

### 自动解包机制

```javascript
const count = ref(0)
const state = reactive({
  count  // 在 reactive 中自动解包
})

console.log(state.count)  // 0（不需要 .value）
state.count++  // 直接操作

// 但在数组和 Map 中不会自动解包
const arr = reactive([ref(0)])
console.log(arr[0].value)  // 需要 .value

const map = reactive(new Map([['count', ref(0)]]))
console.log(map.get('count').value)  // 需要 .value
```

### 性能考量

```javascript
// reactive: 深度响应式（递归转换）
const state = reactive({
  nested: {
    deep: {
      value: 1
    }
  }
})
// 访问 state.nested.deep.value 时，每一层都会被转换为响应式

// ref: 只有 .value 是响应式的
const obj = ref({
  nested: {
    deep: {
      value: 1
    }
  }
})
// obj.value 是响应式的，但内部对象会被 reactive() 处理
```

### 最佳实践建议

| 场景 | 推荐方案 | 原因 |
|------|---------|------|
| 基本类型 | `ref()` | 唯一选择 |
| 对象/数组 | `reactive()` | 更简洁，无需 `.value` |
| 需要重新赋值 | `ref()` | 保持响应式引用 |
| 组合式函数返回 | `ref()` | 解构后仍保持响应式 |
| 大型对象 | `shallowReactive()` | 性能优化 |

---

## 性能优化策略

### 浅层响应式

#### shallowReactive()

```javascript
const state = shallowReactive({
  count: 0,
  nested: {
    value: 1
  }
})

// ✅ 根级属性是响应式的
state.count++  // 触发更新

// ❌ 嵌套对象不是响应式的
state.nested.value++  // 不触发更新

// ✅ 替换整个嵌套对象会触发更新
state.nested = { value: 2 }  // 触发更新
```

> [!tip] 使用场景
> - 大型列表数据（只需要响应式的根级属性）
> - 集成第三方状态管理库
> - 性能敏感的场景

#### shallowRef()

```javascript
const state = shallowRef({
  count: 0,
  nested: { value: 1 }
})

// ❌ 修改内部属性不触发更新
state.value.count++  // 不触发更新

// ✅ 替换整个 .value 触发更新
state.value = { count: 1, nested: { value: 2 } }  // 触发更新

// 手动触发更新
import { triggerRef } from 'vue'
state.value.count++
triggerRef(state)  // 强制触发更新
```

> [!tip] 使用场景
> - 大型不可变数据结构
> - 集成外部状态管理（如 Redux）
> - 性能优化（避免深度响应式转换）

### 只读响应式

```javascript
const original = reactive({ count: 0 })
const copy = readonly(original)

// ❌ 无法修改
copy.count++  // 警告：Set operation on key "count" failed: target is readonly

// ✅ 但仍然响应原始对象的变化
original.count++
console.log(copy.count)  // 1
```

> [!info] 使用场景
> - 防止子组件修改父组件的状态
> - 提供只读的全局状态
> - 性能优化（跳过 setter 的处理）

### computed 的缓存机制

```javascript
const count = ref(0)

// computed 会缓存计算结果
const double = computed(() => {
  console.log('computing...')
  return count.value * 2
})

console.log(double.value)  // computing... 0
console.log(double.value)  // 0（使用缓存，不再计算）

count.value++
console.log(double.value)  // computing... 2（依赖变化，重新计算）
```

**computed 的实现原理**：

```javascript
class ComputedRefImpl {
  private _value
  private _dirty = true  // 脏标记

  constructor(getter) {
    this.effect = new ReactiveEffect(getter, () => {
      // 调度器：依赖变化时，只标记为脏，不立即计算
      if (!this._dirty) {
        this._dirty = true
        triggerRefValue(this)  // 通知依赖 computed 的 effects
      }
    })
  }

  get value() {
    // 依赖收集
    trackRefValue(this)

    // 只在脏时重新计算
    if (this._dirty) {
      this._dirty = false
      this._value = this.effect.run()
    }

    return this._value
  }
}
```

> [!success] 性能优势
> - **惰性计算**：只在访问时才计算
> - **缓存结果**：依赖不变时直接返回缓存
> - **避免重复计算**：多次访问只计算一次

### 调试工具

```javascript
const count = ref(0)

const double = computed(() => count.value * 2, {
  // 依赖被追踪时触发
  onTrack(e) {
    console.log('Tracked:', e)
    // { effect, target, type: 'get', key: 'value' }
  },

  // 依赖变化触发更新时触发
  onTrigger(e) {
    console.log('Triggered:', e)
    // { effect, target, type: 'set', key: 'value', newValue, oldValue }
  }
})

// 访问 double.value 会触发 onTrack
console.log(double.value)

// 修改 count 会触发 onTrigger
count.value++
```

> [!tip] 使用场景
> - 调试响应式依赖关系
> - 性能分析（找出不必要的依赖）
> - 理解响应式系统的工作流程

---

## 实践应用与最佳实践

### 组合式函数中的响应式

```javascript
// ✅ 推荐：返回 ref，解构后仍保持响应式
function useCounter() {
  const count = ref(0)
  const double = computed(() => count.value * 2)

  function increment() {
    count.value++
  }

  return { count, double, increment }
}

// 使用
const { count, double } = useCounter()  // ✅ 解构后仍响应式

// ❌ 不推荐：返回 reactive，解构后失去响应式
function useCounter() {
  const state = reactive({
    count: 0,
    double: computed(() => state.count * 2)
  })

  return state
}

const { count } = useCounter()  // ❌ count 不再响应式
```

### 避免响应式丢失

```javascript
// ❌ 错误：直接解构 reactive 对象
const state = reactive({ count: 0 })
let { count } = state  // count 不再响应式

// ✅ 方案 1：使用 toRefs
import { toRefs } from 'vue'
const { count } = toRefs(state)  // count 是 ref

// ✅ 方案 2：不解构，直接使用
const state = reactive({ count: 0 })
// 使用 state.count

// ✅ 方案 3：使用 ref
const count = ref(0)
const { value: countValue } = count  // 仍然需要通过 count.value 访问
```

### 性能优化实践

```javascript
// ❌ 不必要的深度响应式
const list = reactive({
  items: [
    { id: 1, name: 'Item 1', data: { /* 大量数据 */ } },
    // ... 1000+ items
  ]
})

// ✅ 使用 shallowReactive
const list = shallowReactive({
  items: [/* ... */]
})

// 只在需要时手动触发更新
function updateItem(index, newItem) {
  list.items[index] = newItem
  // 如果需要，手动触发更新
  list.items = [...list.items]
}

// ✅ 或使用 markRaw 标记不需要响应式的数据
import { markRaw } from 'vue'

const list = reactive({
  items: [
    { id: 1, name: 'Item 1', data: markRaw({ /* 大量数据 */ }) }
  ]
})
```

### 常见陷阱

#### 陷阱 1：在 setup 外部创建响应式数据

```javascript
// ❌ 错误：在模块顶层创建
const state = reactive({ count: 0 })

export default {
  setup() {
    // 所有组件实例共享同一个 state
    return { state }
  }
}

// ✅ 正确：在 setup 内部创建
export default {
  setup() {
    const state = reactive({ count: 0 })
    return { state }
  }
}
```

#### 陷阱 2：异步操作中的响应式丢失

```javascript
// ❌ 错误
const state = reactive({ user: null })

async function fetchUser() {
  const user = await api.getUser()
  state = reactive({ user })  // ❌ 失去响应式！
}

// ✅ 正确
const state = reactive({ user: null })

async function fetchUser() {
  const user = await api.getUser()
  state.user = user  // ✅ 保持响应式
}
```

#### 陷阱 3：在 computed 中修改响应式数据

```javascript
// ❌ 错误：computed 应该是纯函数
const count = ref(0)
const double = computed(() => {
  count.value++  // ❌ 副作用！可能导致无限循环
  return count.value * 2
})

// ✅ 正确：使用 watchEffect 或 watch
watchEffect(() => {
  if (count.value > 10) {
    count.value = 0
  }
})
```

---

## 总结

### 核心要点回顾

> [!summary] 关键知识点
>
> **1. Proxy 的优势**
> - 完整的对象拦截能力
> - 原生支持数组和新增/删除属性
> - 惰性响应式转换，性能更好
>
> **2. 依赖收集机制**
> - 使用 `WeakMap<target, Map<key, Set<effect>>>` 存储依赖
> - `track()` 在 getter 中收集依赖
> - `trigger()` 在 setter 中触发更新
> - `activeEffect` 追踪当前执行的 effect
>
> **3. ref vs reactive**
> - `ref`：适合基本类型和需要重新赋值的场景
> - `reactive`：适合对象，使用更简洁
> - 组合式函数推荐返回 `ref`
>
> **4. 性能优化**
> - 使用 `shallowReactive`/`shallowRef` 避免深度转换
> - 使用 `readonly` 提供只读状态
> - 使用 `computed` 的缓存机制
> - 使用 `markRaw` 标记不需要响应式的数据

### 适用场景建议

| 场景 | 推荐方案 | 原因 |
|------|---------|------|
| 组件状态 | `reactive` 或 `ref` | 根据数据类型选择 |
| 组合式函数 | 返回 `ref` | 解构后保持响应式 |
| 大型列表 | `shallowReactive` | 性能优化 |
| 全局状态 | `readonly` + `reactive` | 防止意外修改 |
| 计算属性 | `computed` | 自动缓存 |
| 外部状态集成 | `shallowRef` + `triggerRef` | 手动控制更新 |

### 延伸阅读

> [!info] 相关资源
> - [Vue 3 官方文档 - 深入响应式系统](https://vuejs.org/guide/extras/reactivity-in-depth.html)
> - [Vue 3 源码 - reactivity 包](https://github.com/vuejs/core/tree/main/packages/reactivity)
> - [Proxy MDN 文档](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy)
> - [Vue 3 设计理念](https://github.com/vuejs/rfcs)

---

## 参考资料

- [Vue 3 官方文档](https://vuejs.org/)
- [Vue 3 源码仓库](https://github.com/vuejs/core)
- [Vue 3 Reactivity API](https://vuejs.org/api/reactivity-core.html)
- [Evan You - Vue 3 Deep Dive](https://www.youtube.com/watch?v=WLpLYhnGqPA)

---

%%
相关笔记：
- [[前端/Vue 3 组合式 API]]
- [[前端/JavaScript Proxy 详解]]
- [[前端/性能优化最佳实践]]
%%

#前端/Vue #响应式系统 #源码分析 #性能优化 #JavaScript/Proxy

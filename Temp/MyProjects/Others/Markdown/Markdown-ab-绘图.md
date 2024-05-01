# Markdown 的绘图

## mermaid (支持很多图，不能一一列举)

### mermaid graph

```mermaid
%% mermaid 的 graph
%% 图的方向是水平的。graph TD 则是垂直的。
graph LR

    %% 用个框围起来
    subgraph SGA
        A[Square shape]
        B(Rounded square shape)
        C((Circle shape))
        %% 还有很多形状

        A --- B --> |Two line<br />edge comment| C
        B -.- A
        C ==> B
        %% 还有很多种线
    end

    D{Diamond}
    od>Odd shape]
    db[(Database)]

    %% 填充与边框
    classDef green fill:#9f6,stroke:#333,stroke-width:2px;
    classDef orange fill:#f96,stroke:#333,stroke-width:4px;
    class A,B green
    class C orange
```

```mermaid
%% 用 mermaid 的 graph 画思维导图
graph LR

    A(主题A)
        AA(主题AA)
            AAA(主题AAA)
            AAB(主题AAB)
                AABDesc(主题AAB描述)
        AB(主题AB)
            ABA(主题ABA)
            ABB(主题ABB)

    A --- AA
    A --- AB
    AA --- AAA
    AA --- AAB -.- AABDesc
    AB --- ABA
    AB --- ABB

```

```mermaid
%% 用 mermaid 的 graph 画流程图
graph TD
    A(用户登陆)
    B[登陆操作]
    C{登陆成功 Yes or No?}
    D[进入后台]

    A --> B --> C
    C -->|yes| D
    C -->|no| A
```

### mermaid sequenceDiagram

```mermaid
%% mermaid 的时序图
sequenceDiagram
    Alice ->> Bob: Hello Bob, how are you?
    Bob-->>John: How about you John?
    Bob--x Alice: I am good thanks!
    Bob-x John: I am good thanks!
    Note right of John: Bob thinks a long<br/>long time, so long<br/>that the text does<br/>not fit on a row.

    Bob-->Alice: Checking with John...
    Alice->John: Yes... John, how are you?
```

```mermaid
sequenceDiagram
    loop Daily query
        Alice->>Bob: Hello Bob, how are you?
        alt is sick
            Bob->>Alice: Not so good :(
        else is well
            Bob->>Alice: Feeling fresh like a daisy
        end

        opt Extra response
            Bob->>Alice: Thanks for asking
        end
    end
```

```mermaid
sequenceDiagram
    participant Alice
    participant Bob
    Alice->>John: Hello John, how are you?
    loop Healthcheck
        John->>John: Fight against hypochondria
    end
    Note right of John: Rational thoughts<br/>prevail...
    John-->>Alice: Great!
    John->>Bob: How about you?
    Bob-->>John: Jolly good!
```

### mermaid classDiagram

```mermaid
classDiagram
	%% 返回值是可选的
    class BankAccount
    BankAccount : +String owner
    BankAccount : +Bigdecimal balance
    BankAccount : +deposit(amount) bool
    BankAccount : +withdrawl(amount) int
```

```mermaid
classDiagram
	%% 定义类的另外一种方法
    class BankAccount{
        +String owner
        +BigDecimal balance
        +deposit(amount) bool
        +withdrawl(amount)
    }
```

```mermaid
classDiagram
class Square~Shape~
Square : id int
Square : position List~int~
Square : setPoints(List~int~ points)
Square : getPoints() List~int~
Square : -List~string~ messages
Square : +setMessages(List~string~ messages)
Square : +getMessages() List~string~
```

```mermaid
classDiagram
    classA <|-- classB
    classC *-- classD
    classE o-- classF
    classG <-- classH
    classI -- classJ
    classK <.. classL
    classM <|.. classN
    classO .. classP
```
```mermaid
classDiagram
    classA --|> classB : Inheritance
    classC --* classD : Composition
    classE --o classF : Aggregation
    classG --> classH : Association
    classI -- classJ : Link(Solid)
    classK ..> classL : Dependency
    classM ..|> classN : Realization
    classO .. classP : Link(Dashed)
```

### mermaid stateDiagram

```mermaid
stateDiagram-v2
    [*] --> First: A transition

    state First {
        [*] --> Second

        state Second {
            [*] --> second
            second --> Third

            state Third {
                [*] --> third
                third --> [*]
            }
        }
    }
```

```mermaid
stateDiagram-v2
    state fork_state <<fork>>
      [*] --> fork_state
      fork_state --> State2
      fork_state --> State3

      state join_state <<join>>
      State2 --> join_state
      State3 --> join_state
      join_state --> State4
      State4 --> [*]
```

```mermaid
stateDiagram-v2
    State1: The state with a note
    note right of State1
        Important information! You can write
        notes.
    end note
    State1 --> State2
    note left of State2 : This is the note to the left.
```

```mermaid
stateDiagram-v2
    [*] --> Active

    state Active {
        [*] --> NumLockOff
        NumLockOff --> NumLockOn : EvNumLockPressed
        NumLockOn --> NumLockOff : EvNumLockPressed
        --
        [*] --> CapsLockOff
        CapsLockOff --> CapsLockOn : EvCapsLockPressed
        CapsLockOn --> CapsLockOff : EvCapsLockPressed
        --
        [*] --> ScrollLockOff
        ScrollLockOff --> ScrollLockOn : EvCapsLockPressed
        ScrollLockOn --> ScrollLockOff : EvCapsLockPressed
    }
```

### mermaid pie

```mermaid
%% mermaid 的饼图
pie title What Voldemort doesn't have?
    "FRIENDS" : 2
    "FAMILY" : 3
    "NOSE" : 45
```

### mermaid gantt

```mermaid
gantt

%% mermaind 的甘特图

    title A Gantt Diagram
    dateFormat  YYYY-MM-DD
    section Section
    A task           :a1, 2014-01-01, 30d
    Another task     :after a1  , 20d
    section Another
    Task in sec      :2014-01-12  , 12d
    another task      : 24d
```

## 绘制流程图 Flowchart

```flow
st=>start: 用户登陆
op=>operation: 登陆操作
cond=>condition: 登陆成功 Yes or No?
e=>end: 进入后台

st->op->cond
cond(yes)->e
cond(no)->op
```

## 绘制序列图 Sequence Diagram

```sequence
    Alice ->> Bob: Hello Bob, how are you?
    Bob-->>John: How about you John?
    Bob--x Alice: I am good thanks!
    Bob-x John: I am good thanks!
    Note right of John: Bob thinks a long<br/>long time, so long<br/>that the text does<br/>not fit on a row.

    Bob-->Alice: Checking with John...
    Alice->John: Yes... John, how are you?
```

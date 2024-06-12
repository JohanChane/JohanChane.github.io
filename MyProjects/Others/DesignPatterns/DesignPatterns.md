# Design Patterns

## Content

${toc}

## 说明

GoF 23 种设计模式

[Online Server of PlantUML](http://www.plantuml.com/plantuml/uml/SyfFKj2rKt3CoKnELR1Io4ZDoSa70000)

## References

-   《设计模式：可复用面向对象软件的基础》
-   《Head First 设计模式》
-   [设计模式](https://www.runoob.com/design-pattern/design-pattern-tutorial.html)
-   [设计模式 (计算机)](https://zh.wikipedia.org/wiki/%E8%AE%BE%E8%AE%A1%E6%A8%A1%E5%BC%8F_(%E8%AE%A1%E7%AE%97%E6%9C%BA))
-   [JakubVojvoda/design-patterns-cpp](https://github.com/JakubVojvoda/design-patterns-cpp)

## Creational patterns（创建型模式）

### Abstract factory（抽象工厂）

意图

> 为一个产品族提供了统一的创建接口。当需要这个产品族的某一系列的时候，可以从抽象工厂中选出相应的系列创建一个具体的工厂类。

![](http://www.plantuml.com/plantuml/png/jP91ou9048Rlyols-7q4WjUGHIVet5_Orga4KzWT3r7-zzRKRKaBExGWWi_3l2_ZffQLuUPS0d1z93wH4LSGxXGLapaeJIBRMpPAyyxKUQCv6uGM7YzTAcl5o68Fs-KJySD4_6xYrZsrkNHyE2kX3IcciU7VlrZxkkyi32sSbXjYuf_akAG-PLCMLB7BS5-U2uwYcvpyav7ZF4VmZJqErWNGHpauOQvVaZIMf9oHVFuY2mChB2I3wzCP_Ogad7NmnO6Kghoxm7S0)

plantuml code

```plantuml
@startuml

together {
    interface AbstractProductA {
    }

    class ProductA1 {
    }
}

together {
    interface AbstractProductB {
    }

    class ProductB1 {
    }
}

together {
    interface AbstractFactory {
        + createProductA() : ProductA
        + createProductB() : ProductB
    }

    class Factory1 {
        + createProductA() : ProductA
        + createProductB() : ProductB
    }
}

class Client {
}

ProductA1 ..|> AbstractProductA
ProductB1 ..|> AbstractProductB
Factory1 ..|> AbstractFactory

Client ..> AbstractFactory : <<use>>
Client ..> AbstractProductA : <<use>>
Client ..> AbstractProductB : <<use>>

Factory1 ..> ProductA1 : <<create>>
Factory1 ..> ProductB1 : <<create>>

@enduml
```

### Builder（生成器）

意图

> 将一个复杂对象的构建与它的表示分离，使得同样的构建过程可以创建不同的表示。

![](http://www.plantuml.com/plantuml/png/bL91RiCW4BppYfLFZYhx0KvYfMaV4FK73bvNI1GgMDf3cxyN79PQg9VwOfZTcPrPSV8qEGflMWYf9-_XukmS9C6Nk0cX3A5R9ebm3ahFw28CyNk0QxfV8lMntTNGEK8trdkoHZea_9y0Gwz8B-Y3fdO70tlx5NzM3YLPLktWcgSCR3ZhI6iykI3lEXzMpHk7Mg79WMktVVyz5Ya6cowFQQ3hR37n1taiwnpWS8Z5YN0SHPwOwanU6u9FLM4i8MXS2EnI6eQXsOHeKYvEsrUxh0gyKJGp9EbgmDtCIgi3oEf-18EVTLUxsw_aacJEXzpEU5kfPHftzoKT2_BgtlF_MFlfDwzZlubtYiVqedy0)

plantuml code

```plantuml
@startuml

class Product {
}

interface Builder {
    + buildPartA()
    + buildPartB()
}

class ConcreteBuilder {
    + buildPartA()
    + buildPartB()
    + getResult() : Product
}

class Director {
    - builder : Builder
    + construct() : void
}

class Client {
}

ConcreteBuilder ..|> Builder
Builder "-builder" --o Director
ConcreteBuilder ..> Product : <<create>>
Client ..> Director : <<use>>

note left of Director::"construct()"
    builder.buildPartA()
    builder.buildPartB()
end note

note left of Client
    ConcreteBuilder concreteBuilder = new ConcreteBuilder();
    Director director = new Director(concreteBuilder);
    director.construct();
    Product product = concreteBuilder.getResult();
end note

@enduml
```

### Factory method（工厂方法）

意图

> 定义一个接口用于创建对象，但是让子类决定初始化哪个类。工厂方法把一个类的实例化下放到子类。

![](http://www.plantuml.com/plantuml/png/SoWkIImgAStDuShCAqajIajCJbK8ACfFAKqkKQZcgkNYIiv9B2vMSCxFAqejIKMHGMXmBafDBCal0Weh086sGZA8dwgXgM05Cml39EAqe5chfrTZ1vT6DGWY1-LWojcX-y1AmSO6OgUT7HTNNdv9ga9EQbg9GduQp10hAoMOevJ0ZjJNLtYwhEdPl3dFvdG-NJBhoOvLJrktFzax-SckvKydDuALG3MKL1QaQZvkQE9ApKjH09dDnUK0P8926G00)

plantuml code

```plantuml
@startuml
interface Product {
}

class ConreteProduct {
}

interface Creator {
    + create() : Product
}

class ConreteCreator {
    + create() : Product
}

ConreteProduct ..|> Product
ConreteCreator ..|> Creator
ConreteCreator ..> ConreteProduct : <<create>>

note left of Creator::"create()"
    // 如果有多个具体产品
    create(type)。
end note

@enduml
```

### Prototype（原型）

意图

> 用原型实例指定创建对象的种类，并且通过拷贝这些原型创建新的对象。

![](http://www.plantuml.com/plantuml/png/dPBFIiD04CRl-nH3JYsI53q6b88lu2k4EC70EXCsKwIeK0h-WO8Fu471OmN5KuklOrFYMvY49HjA3j8zxJBVzyrlXXtd4XcPN6gbKX8qIHGZd1aMbcc6SAsWEWSGQoOS325qDNMhLAoZF8TJfjYWO5iwtDDtz4-VJf74Qdt8MjgEskPmXYQIb6amhFqzf45mSzAnzJ3jADnoFBzjxO7limLJYbWGD2O2dFHi9mmzEv_NO5RLYI6G2uIOisbjob4d2kaSwgZTmAPB5UA6iq6Z4HGVRzl7LVcvsdxDD-lPPhqidbwBbqLnj_XzlYyVbkNt-yzitiZT98HNxd7iDXfOpWxAkBhMt-KF)

plantuml code

```plantuml
@startuml

interface Prototype {
    + clone() : Prototype
}

class ConcretePrototype1 {
    + clone() : Prototype
}

class ConcretePrototype2 {
    + clone() : Prototype
}

class Client {
    - prototype : Prototype
    + operation()
}

ConcretePrototype1 ..|> Prototype
ConcretePrototype2 ..|> Prototype
Prototype "-prototype" --o Client

note left of ConcretePrototype1::"clone()"
    return the copy of self
end note

note left of Client::"operation()"
    // 客户请求一个原型克隆自身。
    Prototype newPrototype = prototype.clone()
end note

@enduml
```

### Singleton（单件）

意图

> 确保一个类只有一个实例，并提供对该实例的全局访问。

![](http://www.plantuml.com/plantuml/png/VLB1IiD04BtlLmpj9KLjxos5YdZefPSAdjTaqYnkPdKpswAIitWIFFW7Ve17GV1hBFWNhccico2PIuR9Us_cxSoiO6dPvLg8MCkYWAMYbKOs17S2V1o18tNjS4uUIJ72E8Ju6gkuh97x7z6WgXp02lcN60t-fvP2a644ZIc3IVyWut6lGUzLcgCHzFjzsDu_RLyVjizld--FLTqYEqkjOKL8-NhvQ59K6hMyJQT0Jkk1jrv7SKDnPWsfMqoY_MZ3wgq2MDtcF4E2t5W4pYG1RunFBCga0Ei85F5F0I5Ljk2g5SGPnfTGoDnpL8w7RKdFa6kZ4b3ra4dGm53D0iL0YBwFnr_WJjL3vKeg6eQQtQvRCLyipuuN9wVW4RW9zpjfO4lHpCfW9NkHYK1AW0nZnyQRetMl_CggjMI4tIL1gaZguCBQBjiMsiVHARussdyrTkexhGEFCv-wN8jl)

plantuml code

```plantuml
@startuml

class Singleton {
    - uniqueInstance : Singleton {static}
    - Singleton()
    + getInstance() : Singleton {static}
}

note left of Singleton::"getInstance()"
    // ### 懒汉方式
    return uniqueInstance

    // ### 饿汉方式
    if(uniqueInstance == null){
        synchronized(Singleton.class){
            // When more than two threads run into the first null check same time,
            // to avoid instanced more than one time, it needs to be checked again.
            if(uniqueInstance == null){
                INSTANCE = new Singleton();
            }
        }
    }
    return INSTANCE;
end note

note left of Singleton::"uniqueInstance"
    // ### 懒汉方式
    private static final Singleton uniqueInstance = new Singleton()

    // ### 饿汉方式
    private static volatile Singleton uniqueInstance = null
end note

@enduml
```

[有两种方式实现](https://zh.wikipedia.org/wiki/%E5%8D%95%E4%BE%8B%E6%A8%A1%E5%BC%8F)

1.  懒汉方式。指全局的单例实例在第一次被使用时构建。
2.  饿汉方式。指全局的单例实例在类装载时构建。

[*C++和双重检查锁定模式(DCLP)的风险*](https://blog.csdn.net/linlin003/article/details/79012416)

> 因为 C/C++ 语言没有线程的概念，所以只用 C/C++ 通过双重检查锁定模式(DCLP)来实现线程安全的单例模式是不可能的。

## Structural patterns（结构型模式）

### Adapter（适配器）

意图

> 将某个类的接口转换成客户端期望的另一个接口表示。适配器模式可以消除由于接口不匹配所造成的类兼容性问题。

#### Object adapter（对象适配器）

用组合的方法实现。

![](http://www.plantuml.com/plantuml/png/T8xDQiCm48Jl-nI3JYt5XbvTA2szzr3w0a8U5OChETBwbEJTGumaGaoEk_CptqTMctJzdqMce4pUEkBNfZygZW80BqWyhCpwz2nd4JVRdF4LWqjKDcTJFaUxA5C9Tx3RJGn5uUFIOcYxUQ6R_EH-Rgrtotr_UY-yKgVtFwBh8anXCHLI94GbPdf5zFKx3AR1cGsbvFeTq9imZBYMb2gRyVswPUhmPKzszC72y_di7K_sx7c_f-Tf_wfdCzO_czFvj7t1anshdlKjVTg_-CcEtgSJUXutD86rF-rV_tpA2hWfJrjRd-wT33TeLilJjHEURzmDL0tpzDCD6u5cljYx1cJQp1L0MvxitG_N_wXXpjF-6Syw9Zngc8ja2j28f_EwGNOY_E40P8BI0m00)

plantuml code

```plantuml
@startuml

interface Target {
    + request()
}

class ConcreteTarget {
}

class Adapter {
    - adaptee : Adaptee
    + request()
}

class Adaptee {
    + specificRequest()
}

ConcreteTarget ..|> Target
Adapter ..|> Target
Adaptee --o "adaptee" Adapter

note left of Adapter::"request()"
    adaptee.specificRequest();
end note

note as N1
    Adaptee 与 Target 相似，只是有几个接口不同。
    可用 Adaptee 充当 Target 的子类。Adapter 就是转接器，使 Adaptee “变成” Target 的类型。
end note

@enduml
```

#### Class adapter（类适配器）

用多继承的方法实现。

![](//www.plantuml.com/plantuml/png/V8x12i8m44Jl-nLBJufKy5f15EyUn1zOqwq4ObAJhHVrtmqObwhW77VUxCmw2KKPpWwCevJmGF74WZV0h1b6lWoSP3A51nHY6xo9BAoaEfkMUk7u9rmGLYJrR6ndpNwCVZNKzNrLTi6xOdJ31llXwApvCBKfkz5UIHZ01s5qt0c63WlSD9NEh02pw1MS_qnR0liMVT1Nb72tU3P51Ya8mq0KlPf72s9HiJO1NLIj8eXGYbAx2vZWNUhyn9rNS29qw6uMyz-RpwICoCWMmrNnOCcvhykXcr2seLfYVYRRXE8AVI6xXidVQlgFGxTnMmi5MGQ_4T1-Xhk9tPEtXuPuTCpy-5kYxMgsa7z9lbSLT1aMfbV74OKHEAsIKtfCUEBV_m00)

plantuml code

```plantuml
@startuml

class Target {
    + request()
}

class ConcreteTarget {
}

class Adapter {
    + request()
}

class Adaptee {
    + specificRequest()
}

ConcreteTarget --|> Target
Adapter --|> Target : public
Adapter --|> Adaptee : private

note left of Adapter::"request()"
    adaptee.specificRequest();
end note

note as N1
    Adaptee 与 Target 相似，只是有几个接口不同。
    可用 Adaptee 充当 Target 的子类。Adapter 就是转接器，使 Adaptee “变成” Target 的类型。
end note

@enduml
```

### Bridge（桥接）

意图

> 将抽象部分与它的实现部分分离，使它们都可以独立地变化。

![](http://www.plantuml.com/plantuml/png/ZP4nhiCW38Ptdy9YUazFv00Pdb9rwjeRK68a908Hk5EQknUQLYLDXdh2ykyF_fykiOfy7Ho0kYIEIZDgfrB2mxErmUC4c4kY7KP70taE4LiylRl7_0_3I56LZPzVd5wy6MQ0XNacOptrM_HgjUYjPuf6QQflsOhpSD4l_6FmEXBJTpixhv7ozbyxXprYqsHHRRuU2bc5938mh7ZW0nCwCep1xEJHjg9AGW3cge3DXmloFHOYG9UFvHll)

plantuml code

```plantuml
@startuml

abstract class Abstraction {
    - implementor : Implementor
    + operation() {abstract}
}

class RefinedAbstraction {
    + operation()
}

interface Implementor {
    + operationImp()
}

class ConcreteImplementor {
    + operationImp()
}

RefinedAbstraction --|> Abstraction
ConcreteImplementor ..|> Implementor
Implementor "-implementor" --o Abstraction

note left of RefinedAbstraction::"operation()"
    implementor.operationImp()
end note

@enduml
```

### Composite（组合）

意图

> 把多个对象组成树状结构来表示局部与整体，这样用户可以一样的对待单个对象和对象的组合。（一个结点或多个结点都可看作是一棵树）

![](http://www.plantuml.com/plantuml/png/jP8_Rl904CNxESN85UZ3tm5GX91ekSHYnc39ta6xGvea4eeYb08fAQFa1ZHfAPBJnEHFbIjalNQyHA9b2ylxPiRl_KOUMb56baKEe2PMZ4e4arnPYoCk5gn92ru0klCF4rvgwNInZvcMHbFJQQVRl1ig-9pQwunaDC_oKES56IKPQwTS0TGsOrBfQHqyYCs46fiOash8a7O-uypAMOiwE4qEpnZ7buEmL0YfZXNytgFuDsZacZY006WMmfnIGKw3tkz71ywH3vEoGLB9l8PsF2qzO7EyyFymC-afLXO0ESsgouH5kF0J5KmlUEBxmtEvMvMxRM3uVjcKhslqsFkxxP6E7dwkDdy_4ehuyNZpzRJUtz--hQwhB7K8WA5xkb_r1m00)

plantuml code

```plantuml
@startuml

abstract class Component {
    + count() : int
    + add()
    + remove()
    + getChild()
    + operation()
}

class Leaf {
    + count() : int
    + add()
    + remove()
    + getChild()
    + operation()
}

class Composite {
    - children : List<Component>
    + count() : int
    + add()
    + remove()
    + getChild()
    + operation()
}

Leaf --|> Component
Composite --|> Component
Component "-children" --o Composite

note left of Composite::"operation()"
    for each child in children
        child.operation()
end note

legend bottom
    Leaf, Composite 是一个 Component，但 Leaf 只是一个 Component, 而 Composite 是 Component 的集合。
endlegend

@enduml
```

### Decorator（装饰）

意图

> 动态地给一个对象添加一些额外的职责。就增加功能来说， 装饰模式相比生成子类更为灵活。

![](http://www.plantuml.com/plantuml/png/ZL9RIiH04FplKpIRduXi5lsCAElZ8kDi1nQoqykaHK7t5Xx2IuYN4Ro6apYRZhG1vwipLTLLbMJTYOloi6i1ja4eDiuJtl9kpu62u3DWEgV8UufEjXpA4pW0-DPrNQ857qd8qWsIP7ykSlUTHES5VpRUaUS4S_oViQKRfFHZk5fxpQInXQhgvKfbO8sNoqGO7q41eynJKl140865iAL6a1iRlwuNauoB8VRa8lVkpzYpck0N0tm02XliZRAT6rwXq9CC-6g5HL7Wv_l7r-jRVwEvTIrUOg17HOxBjV7cE9rbhcbphLzZNdq-fxufrI7BLVIxjVPTfx7_kxy1)

plantuml code

```plantuml
@startuml

interface Component {
    + operation()
}

class ConcreteComponent {
    + ConcreteComponent()
    + operation()
}

abstract class Decorator {
    + operation()
}

class ConcreteDecorator {
    + ConcreteDecorator(component : Component)
    + operation()
}

ConcreteComponent ..|> Component
ConcreteDecorator --|> Decorator
Decorator ..|> Component
Component --o Decorator

note left of ConcreteDecorator::"operation()"
    operation() {
        component.operation();
    }
end note

note as Context
    // ### 使用
    Component component = new Component();
    Decorator decorator1 = new ConcreteDecoratorA(component);
    Decorator decorator2 = new ConcreteDecoratorB(decorator1);
    decorator2.operation();
end note

@enduml
```

### Facade（外观）

意图

> 为子系统中的一组接口提供一个一致的界面， 外观模式定义了一个高层接口，这个接口使得这一子系统更加容易使用。

![](http://www.plantuml.com/plantuml/png/ZP9DQiCm48NtSueXAuU2WwMTcvf0e1Ve2OGyTaqLgSGoNOJSlL8q9OeHRRMGxF7tvkTPXzchirzE1a0RDS_ughJg2I-0OJrXxzxSYVpxPCTg2rS0xyRmIcScFfN-K2Fzd4qCyqhvZd7FmrT8UqakodBnJxaiosL17XBmf7NTtRjlSR-Vh3PBJrrN8CIVX5mHS3GJMT_S6CRRbQq94RyXQzzvFCvzoKt9Fx5pQM3hFA6XmQCRk4xRRXxgR6uq_pETZXUqzCMnQljy9qGYH4w81q8cGkQ434JMQ5E71lmo35LAnlBTBhXH0zaUOzi0X_0Oh-at)

plantuml code

```plantuml
@startuml

class Facade {
    + doSomething()
}

together {
    package package1 {
        class Class1 {
        }
    }

    package package2 {
        class Class2 {
        }
    }

    package package3 {
        class Class3 {
        }
    }
}

Facade ..> package1 : <<include>>
Facade ..> package2 : <<include>>
Facade ..> package3 : <<include>>

Client1 ..> Facade : doSomething()
Client2 ..> Facade : doSomething()

together {
    class Client1 {
    }

    class Client2 {
    }
}

note left of Facade::"doSomething()"
    Class1 class1 = new Class1();
    Class2 class2 = new Class2();
    Class3 class3 = new Class3();

    class1.doStuff(class2);
    // ...
end note

@enduml
```

### Flyweight（享元）

意图

> 运用共享技术有效地支持大量细粒度的对象。

例子

> 典型的享元模式的例子为文书处理器中以图形结构来表示字符。一个做法是，每个字形有其字型外观, 字模 metrics, 和其它格式资讯，但这会使每个字符就耗用上千字节。取而代之的是，每个字符参照到一个共享字形物件，此物件会被其它有共同特质的字符所分享；只有每个字符（文件中或页面中）的位置才需要另外储存。
>
> *位置是内蕴状态，存储在非共享享元中。而字型外观，字模等是外蕴状态，存储在共享享元中。共享享元由 FlyweightFactory 放入 map/unordered_map 中管理。*

![](http://www.plantuml.com/plantuml/png/Z55RQiCm4FpNAHP_9HJd04umXK8kK7e0OO_ZfUegI1kIqFhkhTBKCP4fsI_1pcDsz1pL1ZryE6DO5A6p3MZhpaVmhbVwDFGpJ-Jt25RPom8d3IoHcrUrYgKPZ6cSZP5Ul3G1YdjoIInJokEARn9x6z3EA3ykCfAsjb4VpYDt1nrtYtUSbrJTm9Ep74EIus1C7cIr-gedh4dY_u6tHL5sV-zOK5dwBB6vH4WITNvDHPlD8QAkfwZCVXwMfytXHho273ebtsNsLLLaDHQNVhcZHTumHyA9eyPb-eRh1EWXoE-2PKTZ7-iBP22uY0c-2R0A4XpleMbisn8hgIVjGNllNGf-wtXzxwlzhDPW82sbwwyTgDydfUz1mW-ivEdQ6K-RLZpTkUtvkeNF9xGzwsnuDgVpwVgTBpOkV3whHG4rIHO_RcW2wte-POL20df0wc64bHxEj9sWy7J3ngVzwv_iN_TioauqQq2s81pk06G2ypO0)

plantuml code

```plantuml
@startuml

interface Flyweight {
    + operation(extrinsicState)
}

class ConcreteFlyweight {
    - intrinsicState
    + operation(extrinsicState)
}

class UnsharedConcreteFlyweight {
    + operation(extrinsicState)
}

class FlyweightFactory {
    + getFlyweight(key) : Flyweight
}

class Client {
}

ConcreteFlyweight ..|> Flyweight
UnsharedConcreteFlyweight ..|> Flyweight
Flyweight "-flyweights" --o FlyweightFactory
Client ..> FlyweightFactory : <<use>>
Client ..> ConcreteFlyweight : <<use>>
Client ..> UnsharedConcreteFlyweight : <<use>>

note left of FlyweightFactory::"getFlyweight(key)"
    if (getFlyweight(key) is exists) {
        return existing flyweight;
    } else {
        create new flyweight;
        add it to the pool of flyweights;
        return the new flyweight;
    }
end note

note top of Client
    存储并管理所有对象的 extrinsicStates。
    用 `FlyweightFactory.getFlyweight(key).operation(extrinsicState)` 就可修改 extrinsicState。
end note

@enduml
```

### Proxy（代理）

意图

> 为其他对象提供一个代理以控制对这个对象的访问。

![](http://www.plantuml.com/plantuml/png/bPB1IiGm48RlUOgXfoxIxBsxbWLVGFG9uZgxMub9IQQegEzkEfdAU14sXnAc___DH-aXaqiqltfZA9wHBfZWqq0vH-zoXiVvwGMFnBDwRY1Ec1oDCRGRdduRLNX0vwyktQVu_g7Y7MH1zAl1lwW2gw0xFs8eYvU9Dh7sQ_WbyRQ_epNNTBAuWQwBrSi8r5h9izP-FsSS1cD290IF9u9ugeM-RvHYmuxRRUbRlie6gp8wWk4P5gQGqtY-CBfQS7Ar41BSGi0t_UNRpOw3h0CJFsk89wqK9SNljSvEIHpATVazVW00)

plantuml code

```plantuml
@startuml

together {
    class Subject {
        + operation()
    }

    class RealSubject {
        + operation()
    }

    class Proxy {
        - subject : Subject
        + operation()
    }
}

class Client {
}

RealSubject ..|> Subject
Proxy ..|> Subject
Subject "-subject" --o Proxy
Client ..> Subject : <<use>>

note left of Proxy::"operation()"
    // ...
    subject.operation()
    // ...
end note

note right of Client
    Subject subject = new RealSubject();
    Proxy proxy = new Proxy(subject);
    proxy.operation();
end note

@enduml
```

## Behavioural patterns（行为模式）

### Chain of responsibility（责任链）

意图

> 为解除请求的发送者和接收者之间耦合，而使多个对象都有机会处理这个请求。将这些对象连成一条链，并沿着这条链传递该请求，直到有一个对象处理它。

![](http://www.plantuml.com/plantuml/png/RO_1ReCm44Jl-nKZJgqg_04eGf5wwRb_u3fBW-JOgdTzelnxWmDkHB8dc9qPlpsAsgJvuib-YIRh5CvR4NpOSFASC16kqqAoSomI4xfjLpPlE9U_J_x9BFhoYcbhccackhMzn-0IAzVMvzcxW1yvAAP5sOUD-UqhmoOsRILiqBQn6jOcOse67Gw7BDptH24gm_EWYCEUikkQ7LzJiCS1peQLVJrbcPsvw3FOoxsfKfgdTk9mmWAregNn-rpORcVG_pkF1JLwl7xbY_y3)

plantuml code

```plantuml
@startuml

abstract class Handler {
    - successor : Handler
    + handleRequest() {abstract}
}

class ConcreteHandler {
    + handleRequest()
}

class Client {
}

ConcreteHandler ..|> Handler
Handler "-successor" --o Handler
Client ..> Handler : <<use>>

note left of ConcreteHandler::"handleRequest()"
    if can handle {
        handleRequest()
    } else {
        successor.handleRequest()
    }
end note

note right of Client
    handler.handleRequest()
end note

@enduml
```

### Command（命令）

意图

> 将一个请求封装为一个对象，从而使你可用不同的请求对客户进行参数化；对请求排队或记录请求日志，以及支持可取消的操作。
>
> *请求最终会调用接收者具体实现的功能，而调用者只需调用设置好的请求即可。*

![](http://www.plantuml.com/plantuml/png/VL9DRzD05BplhrZvbAea5Hm3L9KuSUq_SCrhiV27P6yA4bGABHKfgbfLL800WK2KZujRBWsGf7-6hErR_WBUx8xJs40EiVtslPbvCxiI2piI7TzZp5wBHMGxWZkU7SVyLkZxTd27FsIy-3LvH0wvcnJnDbyrhzEJHUxepiPVEXPC2pqWfoEeiS2s60D-u4GagEIP7TqEDiDx584Q1BmDKGOr9c4AZLfBXHbzCm7G29f5NkpkXi6SHi-bG6XfLRtDvgFbKi-i67AhQSHOM8I1ofp3AAkSPq4eY7kqBdYuZcgxRPM-MLED66n1wdL61QiQha20MKt1JjSyR_A0xgEgC5JJqXANoSUqry-JYsoKo9DHzle9d9yCU_bfF_s-FHdkgMv0jUe9Q3YWjwhs6xF1U7Wad_xIqAY34wCGk5LTDN8txgfTJKhOGklNcCKAwS59UdoUTtUdvmW2Ji8Cr45cz4ABwQfSWGP0vcBmQ4Dzh8L2X3v4ZNyCyi-FipU9KlJgD4--bQcaRxlPe9UVxMJ7NoydeEnVhUPT126VlSztL3XojpyUFPV9k-pW3BbSRV7v68z6uy6dopPS-STkDqnvURRL5F5QWQZ55SFoy8MyU5c_9vfcCjoNFy_JlI_vX_rwYh-xs_zPjTHNk-DgKDchVMLifVZl-DuV)

plantuml code

```plantuml
@startuml

abstract class Command {
    - receiver : Receiver
    + command(receiver : Receiver)
    + execute()
}

class ConcreteCommand {
}

class Invoker {
    - command : Command
    + setCommand(command : Command)
    + executeCommand()
}

class Receiver {
    + action()
}

class Client {
}

ConcreteCommand --|> Command
Command --o "-command" Invoker
Receiver --o "-receiver" Command

note left of Command::"execute()"
    receiver.action();
end note

note left of Invoker
    Invoker invoker = new Invoker();
    // 客户设置好的 command（请求）
    invoker.setCommand(command);
    Invoker.executeCommand() {
        // 发出请求
        command.execute();
    }
end note

note right of Client
    // 设置请求的接收者
    Receiver receiver = new Receiver();
    Command command = new ConcreteCommand(receiver);
end note

legend bottom
    // 主要目的是让 Invoker 最终调用客户设置的 Receiver.action()（功能的具体实现）
    1.  客户设置命令的接收者, Command command = new <Command>(receiver)
    2.  调用者取得客户设置好的命令，并执行 command.execute()。最终调用客户设置的接收者 receiver.action()。
endlegend

@enduml
```

### Interpreter（解释器）

意图

> 给定一个语言, 定义它的文法的一种表示，并定义一个解释器, 该解释器使用该表示来解释语言中的句子。

例子：`C++ 布尔表达式`

> TerminalExp: true, false, <value><br>
> NonTerminalExp: and, or, not

![](http://www.plantuml.com/plantuml/png/d53DIWCn4BxFKmmvMQGfNbSeGl7goHT8jxCQo6OaCuM2-kvEIpGBHa7dj3lVptnVxaH3qUES0COKH737MUca-0hl0D6-onH6mllJIo6HoDaGjBd62sXRlHghPlXKhqnS_Hwfp367z6-31yu_UgoHlbPYwaRuqubTYfHhvSujxz-sI-jEeWvh0RbrY-cCoFrIK7DulyN-jaO7oAo4YIP5dlfcm-1-A-y0RJORF33AST_ojIUxC1hWlzcjRXSc-aneJ6rwYsRRAFry7YWVyDm38D7J-MVFgZm3sjpuZy4JujEUrgSJLhzOllXbUzVJcIkUxEn-kcJQyrajJtOqFDar-sdhYgSR6vxiN_YiSVtZXYQmPYCzM8o-sD3yVCeAYDvdatkVx9q3L0Eo668Z5vS3a0GcVW00)

plantuml code

```plantuml
@startuml

class Context {
}

interface Expression {
    + interpret(context : Context)
}

class TerminalExpression {
    + interpret(context : Context)
}

class NonTerminalExpression {
    - expressions : Expression
    + interpret(context : Context)
}

class Client {
}

TerminalExpression ..|> Expression
NonTerminalExpression ..|> Expression
Expression "-expression" ..o NonTerminalExpression
Client ..> Expression
Client ..> Context

note left of NonTerminalExpression::"interpret(context : Context)"
    // do subexpression interpret
    expression.interpret(context);
    // do the rest interpret of this NonTerminalExpression.
end note

legend bottom
    1. Context 包含解释器之外的一些全局信息。
    2. Client 调用解释操作。
endlegend

@enduml
```

### Iterator（迭代器）

意图

> 提供一种方法顺序访问一个聚合对象中各个元素, 而又不需暴露该对象的内部表示。

![](http://www.plantuml.com/plantuml/png/ZLBDJiCm3BxdAQoTMg5bzsvKcpWX8TuXAruNgKkbn1KWsBiJawwUcWcMKn9_F_QNR0CPJyEfKqrdGe1dmXDygRDIrX7wWscGxxoXtiTxYEi1ZYQyuWSLvNXswH19IUIfTur7mXbn2JQg1wZWnGRQi5MT5396OThMOsi88tftsPTp_rZSzts7naadwPh5kI6p3-HDGv0wcwIcMQAj4T_4dTg-iC_vRA9qxt12ASh_pKT4YyHIWMlNoj9FPz5HUh8iTws_Qr7CMrykOtqwAYbeNKEcLi5capgkQwL6OqOAZo53uBgK9K-fAjT7T8S7WlwG1rHLYnkXBHJ4HKSRTChw4Ho-myvxyodH5ELQeNi3ThZ3P_u4oIIY1k_oRydcvT_oWexgz_thMvDDG2rVO6xiRNlyTKvXiuY8YiAOqur4rqoHzx6NpRNzFA34MQq4hRMMphPnDvow7m00)

plantuml code

```plantuml
@startuml

class Item {
}

interface Iterator {
    + hasNext()
    + next()
}

class ConcreteIterator {
    - items : List<Item>
    + ConcreteIterator(aggregate : Aggregate)
    + hasNext() : boolean
    + next() : Item
}

abstract class Aggregate {
    + createIterator() : Iterator {abstract}
}

class ConcreteAggregate {
    - items : List<Item>
    + ConcreteAggregate()
    + createIterator() : Iterator
    + getItems() : List<Item>
}

class Client {
}

ConcreteIterator ..|> Iterator
ConcreteAggregate --|> Aggregate
Aggregate ..> ConcreteIterator : <<create>>

Client ..> Aggregate : <<use>>
Client ..> Iterator : <<use>>

note left of ConcreteAggregate::"ConcreteAggregate()"
    this.items = new ArrayList<Item>();
end note

note left of ConcreteAggregate::"createIterator()"
    return ConcreteIterator(this)
end note

note left of ConcreteIterator::"ConcreteIterator(aggregate : Aggregate)"
    this.items = aggregate.getItems()
end note

note right of Client
    Aggregate aggregate = new ConcreteAggregate();
    Iterator iterator = aggregate.createIterator();
    // iterator ...
end note

@enduml
```

### Mediator（中介者）

意图

> 用一个中介对象来封装一系列的对象交互。中介者使各对象不需要显式地相互引用，从而使其耦合松散，而且可以独立地改变它们之间的交互。
>
> Colleagues 都聚合 Mediator，Mediator 也都聚合 Colleagues 即可。这样 Colleagues 之间不用相互聚合。

![](http://www.plantuml.com/plantuml/png/ZLJ1IiD04BtlLmmvjSXkQOuHfE1P1Fs2DPtKG9f0CZtLWZUlwj6JP_q3yNCKwb-u2PbTsjs4vZJBl3TltjibYuPqJPjr8OI-QwZMAK5QwAQ1oweeKAys25i1vfEmncMkgQeXWQk-x3fdi4Aw9KqucSAMn-pwdYdpgZpix8HWaJAjaT2ApM7hpJmQDCAEJsFd9M6TwHIj3-Rr7d6IMlU9Io8WVJH0GkexIW8sXz1n21sVl5mWJoaVBXpAHyG326TDATFda-028iaF8W8fgp6DkG7xmJ3jK2wmOOWT3x15MH52WHb1bNdj98d6GuowgFCCN5-vjpJjhxdzPZDGIjcZRq_P9yUOwvjXU6pXvnre9x1SGcjcm98JCgQO6mct6fS_ts-_pozWVBS9cEFxt-Fh_kbZ__NPGVWM5IT3ztbZjd3w2rEsluX_)

plantuml code

```plantuml
@startuml

abstract class Colleague {
    - mediator : Mediator
    + getState() {abstract}
    + action() {abstract}
}

class ConcreteColleague1 {
    + getState()
    + action()
}

class ConcreteColleague2 {
    + getState()
    + action()
}

interface Mediator {
    + mediate(colleague : Colleague)
}

class ConcreteMediator {
    - concreteColleague1 : ConcreteColleague1
    - concreteColleague2 : ConcreteColleague2
    + mediate(colleague : Colleague)
}

ConcreteColleague1 --|> Colleague
ConcreteColleague2 --|> Colleague
ConcreteMediator ..|> Mediator
Mediator "-mediator" --o Colleague
ConcreteColleague1 "-concreteColleague1" --o ConcreteMediator
ConcreteColleague2 "-concreteColleague2" --o ConcreteMediator

note left of ConcreteMediator::"mediate(colleague : Colleague)"
    if (colleague.getState()) {
        // ...
        concreteColleague1.action()
        OR
        concreteColleague2.action();
    }
end note

note left of ConcreteColleague1::"action()"
    // ...
    // 会向 medator 传递自身
    mediator.mediate(this);
end note

@enduml
```

### Memento（备忘录）

意图

> 备忘录对象是一个用来存储另外一个对象内部状态的快照的对象。备忘录模式的用意是在不破坏封装的条件下，将一个对象的状态捉住，并外部化，存储起来，从而可以在将来合适的时候把这个对象还原到存储起来的状态。

![](http://www.plantuml.com/plantuml/png/VP9DQiCm48NtSug75oMXs0TmKnFekdJH4uXq4a9j2QGnNPJUlV98Gg8_sOtyllbcBFiOn7XPbvdeD9iGyCmBMt7u903e4NDXhUznONdTZhizHcXLe18eNS8zVHNhYxzUhjQ8yt-AJvxZ8OzMUwvpxZd4LjujwMdDcn5FnhEOTwuJVj4Rd4jqVOuxzBshtTIiEWmJ2Z_YS4XhuWvhu6cYqfF0sgTiGiWwOSny5hXpWunZz-ETErqw2bTlOVa39GbwbG_4zWsRxPRpttlAUdNX4JaVwWTj_STORd_4Dm00)

plantuml code

```plantuml
@startuml

class Memento {
    - state
    + getState() : State
    - setState(state : State)
}

class Originator {
    - state
    + createMemento() : Memento
    + restore(memento : Memento)
}

class Caretaker {
    - memento : Memento
}

Memento "-memento" --o Caretaker
Originator ..> Memento : <<create & use>>
Caretaker ..> Originator : <<use>>

note left of Originator::"createMemento()"
    return new Memento(state);
end note

note left of Originator::"restore(memento : Memento)"
    state = memento.getState();
end note

@enduml
```

### Observer（观察者）

意图

> 在对象间定义一个一对多的联系性，由此当一个对象改变了状态，所有其他相关的对象会被通知并且自动刷新。

![](http://www.plantuml.com/plantuml/png/XP9HQiGW48RVFSMGfombEK2WPQ47wCEUm2HZcsArwAHGjdltZcIKu0RM5yNvyytylpb7qe7MBwlKuWY3qHF2snWn_620gm9UJx1-pvgmFQcRKfFLCSAhTrD0mahQGLp7Jvm81hXi9xdt8hmGar8rxGTuFKOAcW5R7u70jS946CgOGj54Ulfeis8dE8bYnaSAvsanlqT6wq74vv6TTzoksqoDvI9nxwBh-xyNA6RgXbt7rPnb-QRfIX8DItnHoCu2cN0hrqsLOgi85Ws1DtVbOMZoepJ9HFLypzb-l_EAReO4hT0o41CbN24Q7q1R2nuML_0nvIlBzsc44kDjr-3Cn_JF_WC0)

plantuml code

```plantuml
@startuml

interface Observer {
    + update()
}

class ConcreteObserver {
    - subject : Subject
    - observerState : State
    + update()
}

abstract class Subject {
    - observers : Observer
    + attach(observer : Observer)
    + detach(observer : Observer)
    + notify()
}

class ConcreteSubject {
    - subjectState : State
    + getState()
    + setState()
}

ConcreteObserver ..|> Observer
ConcreteSubject --|> Subject
Observer "-observers" --o Subject
Subject "-subject" --o ConcreteObserver

note left of ConcreteObserver::"update()"
    observerState = subject.getState()
end note

note left of Subject::"notify()"
    for all o in observers {
        o.update()
    }
end note

@enduml
```

### State（状态）

意图

> 让一个对象在其内部状态改变的时候，其行为也随之改变。状态模式需要对每一个系统可能获取的状态创立一个状态类的子类。当系统的状态变化时，系统便改变所选的子类。

![](http://www.plantuml.com/plantuml/png/bLFDJi904BxlKqnweZ4jqMD93E8Zy09Tom2DjOtT0KoKHACdOzG3HYC7F7hquey4zMKevUOhIDTjqt8mE9UsCz_txJTVirL1FAJEdiUOwnE6JUuWr8aJmY63HQr1c_iD3qiwMD0Dt0RhC-PuN0ZO3dmdH489t_edlhOIdl205D00aV0KASJz3WhAMAhTGfBgib_FuKKwa2BfS8djBAoqfBsYdQL5JVDeKuaNLyfFc7o0PiW3DJ2C85s8CJyW10-R144pxLgMbYsbIKEIQQRnCFGRa10LFNHRxIL-th_IA9TXDhgUZeVHvIWQFaIJc_dpQtp-CZi-cGtUewkxxyd5zECh-hm5EplUXldJQJnuZ8TlqNWGtv-1NVHY__hhkUIqIrtkTL1NVoafXmk4TOj1hhByVUn1CS-IhbSAs9qG-MwbABUngbpjRpcPY6cQyhEVoxIwU4skmGy0)

plantuml code

```plantuml
@startuml

interface State {
    + handle() : void
}

class ConcreteStateA {
    + handle() : void
}

class ConcreteStateB {
    + handle() : void
}

class Context {
    - state
    + request() : void
    + getState() : State
    + setState(state : State) : void
    + changeState() : void
}

ConcreteStateA ..|> State
ConcreteStateB ..|> State

State "-state" --o Context

note left of Context::"request()"
    state.handle()
end note

note right of Context::"changeState()"
    // 某些原因引起状态改变，使得 `request()` 调用相应的 `state.handle()`
    switch(value) {
        case 1:
            setState(new ConcreteStateA());
            break;
        case 2:
            setState(new ConcreteStateB());
            break;
        // ...
    }
end note

@enduml
```

### Strategy（策略）

意图

> 定义一个算法的系列，将其各个分装，并且使他们有交互性。策略模式使得算法在用户使用的时候能独立的改变。

例子

> 有许多算法可对一个正文流进行分行。将这些算法硬编进使用它们的类中是不可取的。不同的时候需要不同的算法。

![](http://www.plantuml.com/plantuml/png/ZP11oi8m58JtSuf7Ll-Ff0Ue80MFu0b2VMq3RPuaJr3Kkzjg8WKtPfKPvfi9QPAwgETf17nGZfrhcGuQdN9_fHjeFXjoOo_Hwp3z_UC1jADBYVOIsiZAFwULBvf3bbAcCYCddhMNy6Q-kglglgEYyB6j5JAsT9co0WHHfkZxGKcwOjUrMUsOrtHXgzMhj-1mfAK2QERhyZrF)

plantuml code

```plantuml
@startuml

interface Strategy {
    + algorithm()
}

class ConcreteStrategy {
    + algorithm()
}

class Context {
    - strategy
    + operation()
}

ConcreteStrategy ..|> Strategy
Strategy --o "-strategy" Context

note right of Context::"operation()"
    strategy.algorithm();
end note

@enduml
```

### Template method（模板方法）

意图

> 定义一个操作中的算法的骨架，而将一些步骤延迟到子类中。模板方法使得子类可以不改变一个算法的结构即可重定义该算法的某些特定步骤。

![](http://www.plantuml.com/plantuml/png/SoWkIImgAStDuU9AJ2ekAKfCBb58paaiBbPmX7ATmRngBWKWq5OeISqjo4aiIVLDBSd8Jz7GX0eN56NcPfPabgNw5wGM9PPavkSvQcWgLCEChCMfp0bLMIqN5yHsv_oyvABKabIexVYimMSso41KetHrQ-nG_SR5bPTVaggGavfMef2VXYfdPQM4xcCbi7tw-We9w3892a-tRtgwRjxplWtlz_IyQEXvDgVpoQxPpwRjVBPvwejbZSysDZrTE-7vnjqGDOyRcc16wUdfWPZO_MTDM9KJcghKl1G5aAUuk1o0J53i0W00)

plantuml code

```plantuml
@startuml

abstract class AbstractClass {
    + templateMethod()
    + primitiveOperationA() {abstract}
    + primitiveOperationB() {abstract}
}

class ConcreteClass {
    + primitiveOperationA()
    + primitiveOperationB()
}

ConcreteClass --|> AbstractClass

note left of AbstractClass::"templateMethod()"
    // `templateMethod()` 已实现，而有些方法要求子类实现。
    // ...
    primitiveOperationA();
    // ...
    primitiveOperationB();
    // ...
end note

@enduml
```

### Visitor（访问者）

意图

> 表示一个作用于某对象结构中的各元素的操作。它使你可以在不改变各元素的类的前提下定义作用于这些元素的新操作。

例子

> 考虑一个编译器，它将源程序表示为一个抽象语法树。该编译器需在抽象语法树上实施某些操作以进行“静态语义”分析，例如检查是否所有的变量都已经被定义了。它也需要生成代码。因此它可能要定义许多操作以进行类型检查、代码优化、流程分析，检查变量是否在使用前被赋初值，等等。
>
> Visitor（作用于元素的操作）: 检查变量是否被定义了；类型检查；检查变量是否在使用前被赋值。<br>
> Element: 抽象语法树（objectStructure）的节点。

![](http://www.plantuml.com/plantuml/png/rLGzRnD14EtlLunSsKA-o5kU8YiGKLCWGNtPZEE3ywsrDvS68aM4MB4420cg425AIWeAX1p-3Fw0od-1jNTyPlS2Hj2GQyuxy-QzsRattiafrbJqqY0WrGTIiAU8L0_s4usI4fKj4WT8NTJmA03p91cXxiGIuLwI9wHit3utu70HsrMPr4XuEyKUPjIgIoy04VYOnWOIuPE8Aecm94V1yYNJECzB23VRkbRTYl-mswFVE8AnJjUnbDYd-Y6R9LhPfdhxIjz_piCOrKSTBrnxixwPNlmz_IsNFbE4a6A7G7KgbuYYsY-vQoKvvyAhlp5razmgOhQ_bDiiBFvTM5mbREvintbdxm5Akakwa5Hev6asGQeqvV-E4hkR9eQlX2YlDFB96CVDiQUTFNOHeeeG0HkU2-x7wSDwmmqA3fe-AzuBmyTju9EV5NxMKUPQFlbPuMQP0shDzTngq6ogoaXuXc7H3yjoY61xkyYntIxJEZdeaa5uvJyX0ySs7iwuPjs8jSdaz6JsyTti_EdtDuF9oxFvwDctaylfs_FnfoysCXcScgo5VJr-4fHUSPJO14R0_IHMP6iB9Xy6qrVFnvSNyz4PG-QZeJdFNhyVVtvHSOtHd0wFfnT3gxoawIWDzTLCaT-HNzfOh_uA5Bgxqbej-FekE-PdqKj_0000)

plantuml code

```plantuml
@startuml

top to bottom direction

together {
    interface Visitor {
        + visitConcreteElement1(concreteElement1 : ConcreteElement1)
        + visitConcreteElement2(concreteElement2 : ConcreteElement2)
    }

    class ConcreteVisitor1 {
        + visitConcreteElement1(concreteElement1 : ConcreteElement1)
        + visitConcreteElement2(concreteElement2 : ConcreteElement2)
    }

    class ConcreteVisitor2 {
        + visitConcreteElement1(concreteElement1 : ConcreteElement1)
        + visitConcreteElement2(concreteElement2 : ConcreteElement2)
    }
}

together {
    interface Element {
        + accept(visitor : Visitor)
    }

    class ConcreteElement1 {
        + accept(visitor : Visitor)
        + operationA()
    }

    class ConcreteElement2 {
        + accept(visitor : Visitor)
        + operationB()
    }

    note left of ConcreteElement1::"accept(visitor : Visitor)"
        visitor.visitConcreteElement1(this)
    end note

    note left of ConcreteElement2::"accept(visitor : Visitor)"
        visitor.visitConcreteElement2(this)
    end note
}

class ObjectStructure {
    - collection
}

class Client {
    - objectStructure : ObjectStructure
    - visitor1 : ConcreteVisitor1
    - visitor2 : ConcreteVisitor2
    + visitor1Walk()
    + visitor2Walk()
}

ConcreteElement1 ..|> Element
ConcreteElement2 ..|> Element
ConcreteVisitor1 ..|> Visitor
ConcreteVisitor2 ..|> Visitor
Element "-collection" --o ObjectStructure
Client .up.> Visitor : <<use>>
Client .right.> ObjectStructure : <<use>>

note left of ObjectStructure::"collection"
    元素的集合，能枚举集合内的元素。
end note

note left of Client::"visitor1Walk()"
    // 将操作（visitor）作用于 objectStructure 的所有元素
    for (Element element : objectStructure) {
        element.accept(visitor1)
    }
end note

@enduml
```

## 设计模板的七大原则

[面向对象的设计模式有七大基本原则：](https://cloud.tencent.com/developer/article/1650116)

-   合成/聚合复用原则（Composite/Aggregate Reuse Principle，CARP）

    尽量使用合成/聚合，而不是通过继承达到复用的目的。

-   依赖倒转原则（Dependency Inversion Principle，DIP）

    依赖于抽象，不能依赖于具体实现。

    很多模式都抽象出一个抽象基类。而客户一般只使用这个抽象基类。

    ”讲了这么多，估计大家对“倒置”这个词还是有点不理解，那到底什么是“倒置”呢？我们先说“正置”是什么意思，依赖正置就是类间的依赖是实实在在的实现类间的依赖，也就是面向实现编程，这也是正常人的思维方式，我要开车就依赖奔驰车，我要使用电脑就直接依赖笔记本电脑，而编写程序需要的是对现实世界的事物进行抽象，抽象的结果就是有了抽象类和接口，然后我们根据系统设计的需要产生了抽象间的依赖，代替了人们传统思维中的事物间的依赖，“倒置”就是从这里产生“。

-   开闭原则（Open Closed Principle，OCP）

    对扩展开放，对修改关闭。

    定义是：一个软件实体如类、模块和函数应该对扩展开放，对修改关闭。模块应尽量在不修改原（是"原"，指原来的代码）代码的情况下进行扩展。

-   里氏代换原则（Liskov Substitution Principle，LSP）

    所有引用基类的地方必须能透明地使用其子类的对象。

    定义是：所有引用基类的地方必须能透明地使用其子类的对象，也可以简单理解为任何基类可以出现的地方，子类一定可以出现。（《Effective C++》中的“条款 36: 绝不重新定义继承而来的 non-virtual 函数” ，因为这样会破坏 is-a 的关系。）

    里氏代换原则是对"开-闭"原则的补充。

-   单一职责原则（Single Responsibility Principle, SRP）

    一个类只负责一个功能领域中的相应职责。

-   接口隔离原则（Interface Segregation Principle，ISP）

    类之间的依赖关系应该建立在最小的接口上。

    当一个接口过于臃肿时，可以接口拆分为多个接口。然后用这个小接口进行灵活地组合。

    如何看待接口隔离原则和单一职责原则：

    > 单一职责原则是从职责角度出发，而接口隔离是从接口角度出发。有可能满足单一职责原则但是不满足接口隔离原则。

-   迪米特法则（Law of  Demeter，LOD），也叫最少知识原则（Least Knowledge Principle，LKP）

    一个软件实体应当尽可能少的与其他实体发生相互作用。知道得越少越好。

    迪米特法则的初衷在于降低类之间的耦合。由于每个类尽量减少对其他类的依赖，因此，很容易使得系统的功能模块功能独立，相互之间不存在（或很少有）依赖关系。迪米特法则不希望类之间建立直接的联系。如果真的有需要建立联系，也希望能通过它的友元类（中间类或者跳转类）来转达。比如：中介者模式。

个人对于原则的关联性划分：

-   合成/聚合复用原则
-   依赖倒转原则
-   开闭原则、里氏代换原则

    强调扩展，排斥修改。

-   单一职责原则、接口隔离原则、迪米特法则

    强调单一，排斥耦合。

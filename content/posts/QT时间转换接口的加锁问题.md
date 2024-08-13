+++
title = "QT时间转换接口的加锁问题"
date = "2024-08-05"
tags = ["QT", "时间转换", "QDatetime"]
categories = ["QT"]
+++

## 遇到问题的场景

-   负责旧司的后台工具, 要转换大量的 K 线文件 (一共百 GB 级别)。用到多线程转换。但是在转换过程中, CPU 占用和磁盘速度没有拉满。
-   因为工具是在 Windows 平台运行的, 所以使用了 [进程资源管理器](https://learn.microsoft.com/zh-cn/sysinternals/downloads/process-explorer) 查看进程的运行情况。发现内核时间占用比较多。所以猜测是加锁导致的。

## 解决问题的思路

-   直接使用控制变量法是最快的。因为线程池的 worker 使用最频繁的代码块是转换 K 线的各个字段的 for 代码。
-   注释该 for 的代码。然后运行, 发现 CPU 占用和磁盘直接拉满。
-   基本确定是该块代码加锁了。
-   这时发现时间转换使用了 QT 的 `QDateTime::fromString`。我不知内部实现, 所以注释日期转换代码。发现 CPU 占用和磁盘速度也是拉满的。
-   所以基本确定是 `QDateTime::fromString` 代码加锁了。
-   最后自己根据时间字符串的分隔符取出各个时间字段 (年、月、日、时、分、秒)。

## 查看 `QDateTime::fromString` 的实现

为了满足自己的好奇心去查看了 QT 的 `QDateTime::fromString` 的实现:
-   发现它会调用 `QLocale`。而 `QLocale` 会使用 `systemData`
-   `systemDate` 是全局资源, 它包含了本地的时区信息。所以每次使用它会加锁。(不定义 `QT_NO_SYSTEMLOCALE` 情况下)

## 总结

-   为了方便, 直接使用了 QT 的时间转换接口 (猜想其内部应该只是字符串处理)。没有想到它加锁了。
-   所以在多线程的代码的代码中, 还是要谨慎使用接口。要留意接口是否加锁。是否使用全局资源 (e.g. 全局变量)。

## 拓展

在之后的多线程的 K 线的时间转换中, 使用了 redis 的 `nolocks_localtime`。See [ref](https://juejin.cn/post/6844903775539298318)

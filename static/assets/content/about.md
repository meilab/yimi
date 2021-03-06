### 非存先生
**非存先生**是一款简单实用的密码生成器，根据用户输入的主密钥和服务名称生成高强度密码。用户只需要保护好自己的主密钥即可，它会根据不同的服务名称为用户生成不同的密码。


当主密钥和服务名称相同时，程序每次都会生成相同的密码。这确保了用户无需记忆不同的复杂密码，记住一个主密钥即可。BTW：服务名称是公开信息，被别人知道了，也无法得到用户的最终密码。

### 特点
* 非存储：程序不会存储用户生成的最终密码。
* 现生成：根据主密钥和服务名动态生成最终密码。
* 简单：用户只需记忆主密码，记忆负担小。
* 更安全：每个服务的密码都不相同，不会因为某个网站的泄密影响用户的多个密码。
* 方便：可以选择让程序记录服务名称，方便用户回顾都有哪些密码是程序生成的。

### 原理
程序实用用户输入的主密钥和服务名称，根据[PBKDF2](https://baike.baidu.com/item/PBKDF2)生成哈希值，然后采用类霍夫曼编码的方式将生成的哈希值映射到用户选定的字符空间(**纯数字**、**字母+数字**、**字母+数字+特殊字符**)。

PBKDF2是非常安全的密码生成算法，被各大组织所采用。程序的这种构架方式保证了最终为用户生成的密码难以被黑客暴力破解，同时保留了极大的灵活性，用户可以选择最终密码的字符集，可以选择高强度密码，或者某些只允许数字的密码系统，例如银行等。

程序目前有提供了**网页版(PWA)**，以及**微信小程序(非存先生)**。程序采用Elm语言编写，源代码开放，免费使用，欢迎感兴趣的同学一起交流学习。

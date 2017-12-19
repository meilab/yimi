生成最终密码使用了两个算法：采用`PBKDF2`来生成密码，使用类霍夫曼编码的方式将生成的密码映射到用户指定的字符空间。

### PBKDF2
**`PBKDF2(Password-Based Key Derivation Function 2)`**是一种密码生成算法，可以有效的防止密码破解，2017年出版的[RFC-8018:Password-Based Cryptography Specification](https://tools.ietf.org/html/rfc8018)仍然推荐使用PBKDF2。

简单理解，PBKDF2是采用一种哈希函数将主密钥和盐进行多轮计算，生成最终密码。轮数越多，黑客破解的难度越高。

这里采用斯坦福大学的[sjcl](https://crypto.stanford.edu/sjcl/)库提供的PBKDF2，安全，可靠，高效。将用户输入的主密钥作为主密钥，将用户输入的服务名处理之后当作盐，来进行PBKDF2，生成一个密码，然后做字符编码。

### 字符编码
PBKDF2生成的密码可能是任意字符。这里为了方便用户使用，可以让用户选择密码的字符空间，可以是高强度的密码（数字 + 字母 + 特殊字符），字母+ 数字，或者纯数字（银行等场景下，只允许纯数字密码）

首先将PBKDF2生成的密码映射映射到数字空间,生成二进制比特流**`a`**。根据用户选择的密码类型合成密码字符空间集，根据字符空间集内字符个数的多少（纯数字时为10，字母+数字时为62。。）决定每次从**`a`**中选择几个二进制数来进行字符映射。

需要注意的是，假如用户选择了高强度密码，我们需要进行一些处理，保证最终生成的密码当中，包含数字，字母和特殊字符，这里详情可以查看源代码：src->Password->Password.elm


### 优势
最终生成的密码，对用户来讲，只需要记忆一个主密钥，保证不被别人知道。服务名可以使用网站名或者其它方便记忆的字符串，甚至可以点击保存，软件帮忙记录服务名，就可以确保所有的网站的密码都不相同，而用户的记忆负担很小，即使某个网站被黑客攻击了，用户的密码不至于都泄漏出去。
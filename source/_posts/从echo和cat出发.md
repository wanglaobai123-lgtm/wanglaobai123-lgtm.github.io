---
title: 从echo和cat出发
date: 2026-10-18 17:29:48      # 发布时间：文章卡片和详情页显示的就是它，想改日期就改这行
# updated: 2026-10-18 20:00:00 # 可选。固定"更新时间"；不写这行则默认显示文件最后修改时间
# tags: [Hexo, 生活]             # 标签：可写多个，用逗号分隔；会出现在文章卡片和"标签"页
categories: [Linux]             # 分类：一般只写一个；会出现在"分类"页
# top: true                    # 取消注释并写 true 可置顶这篇文章
# index_img: /img/cover.png    # 文章封面图：先把图片放进 source/img/ 文件夹，再写这里
---

## 场景

在使用下面代码的时候误把cat打成了echo，结果就是dockerfile最后的内容为空，所以复习一下有关stdin和stdout的内容。

```shell
cat > Dockerfile <<'EOF'
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
EOF
```

## stdin和stdout，stderr

全称略过，stdin是标准输入，代码为0；stdout是标准（正确）输出，代码为；stderror是标准错误输出，代码为2；

## 重定向

和AI讨论了一下，建议我只使用“指向”“接线”“出口”这类指针词汇，不然会容易产生误导。下面是我的理解供未来阅读。

stdin，stdout，stderr是人类的约定，真实情况是每个进程**被创建时**从父进程**继承** fd 表副本，数组下标为0的指针fd0指向键盘（即输入stdin），数组下标为1和2的指针都指向屏幕（约定一个指向stdout，一个stderr），进程每打开一个文件（Linux一切皆文件）3及其后面的指针就会指向对应的文件。

所以`echo "hello world" > hello.txt`其实就是把echo进程的下标为1的指针fd1重新指向文本文件，而`echo "hello world" > hello.txt 2>&1`其实就是把echo进程下标为2的指针fd2指向下标为1的指针fd1指向的地址（这里可以把&理解为c语言里面的*符号，把 fd2 指到 `*fd1` 那个东西上”，按照标准输出的说法就是把stderr也指向到stdout指向的出口，而执行到 `2>&1` 时 fd1 已经指向txt文件了，所以 stderr 跟着指向文件，不指向屏幕。）针对`echo "hello world" 2>&1 > hello.txt`，此时fd2先指向fd1指向的地址（屏幕），然后fd1再指向txt文件，所以stdout指向文件，stderr指向屏幕输出。

## heredoc及场景分析

heredoc是把一段文本直接接给fd0，代替键盘的世界输入，就像示例，两个EOF之间就是heredoc来代替键盘的输入，在原先问题中，cat和echo的区别在于没有参数时，echo不读取fd0，他的输出内容仅来自他的参数，所以只会输出一个空行到fd1；cat则会读取fd0，并且将读到的内容写到fd1里面（`> hellotxt`是将fd1的指向文本文件）。所以问题的本质就是命令读不读fd0，写入fd1还是fd2。

```
cat > hello.txt <<EOF
hello world
EOF
```




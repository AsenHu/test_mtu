# test_mtu
用 ping 测试 mtu

快速使用
```
bash <(curl https://raw.githubusercontent.com/AsenHu/test_mtu/main/mtu.sh)
```

```
# 用法：
mtu.sh ip=1.1.1.1 min=1280 max=1500 --cmd
```

`ip` 为用来 ping 的对象，默认为 IPv4 网关（如果 IPv4 网关不存在会换 IPv6 网关），你可以用来测试你到 cloudflare warp 的节点的 mtu

`min` 为你认为的可能的最小的 mtu 值，默认 28

`max` 为你认为的可能的最大的 mtu 值，默认 65536

`--cmd` 只输出 mtu 值，方便脚本调用

# JHUIControlBlock
Use Control With Block Without Weak-Strong Dance

以 block 方式使用 UIControl 无需使用 Weak-Strong Dance

CSDN block : https://blog.csdn.net/xjh093/article/details/83348381

---

# Example
add a `UIButton` in ` DemoViewController `

add event:
```
[button jh_handleEvent:1<<6 inTarget:self block:^(DemoViewController *vc, id  _Nonnull sender) {

      // use `DemoViewController`
      vc.navigationItem.title = @"blablabla";

      // invoke method
      [vc goNextVC];

      // no longer need `Weak-Strong Dance`
}];
```

---

# Logs
2.fix a small bug of `sender`.(2019-06-11)

1.Upload. (2018-10-24)


# JHUIControlBlock
Use Control With Block Without Weak-Strong Dance

以 block 方式使用 UIControl 无需使用 Weak-Strong Dance

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
1.Upload. (2018-10-24)


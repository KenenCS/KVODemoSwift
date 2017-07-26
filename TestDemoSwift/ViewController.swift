//
//  ViewController.swift
//  TestDemoSwift
//
//  Created by KenenCS on 2017/7/26.
//  Copyright © 2017年 KenenCS. All rights reserved.
//

import UIKit

/*
 Swift中的属性分为两种属性，一种就是计算型属性 一种就是存储型属性.
 计算型属性是什么?
 计算型属性是通过计算而得出来的属性，这种属性相区别于存储属性这种属性是不会存储的。如果是计算型属性，那么提供setter方法那就一定需要提供getter方法，可以直接只有一个getter方法，其实仔细想一想这样的设计是有缘由的，计算型属性我们是为了得出什么？我们是为了获取计算出来的值，那么你提供了setter方法，不提提供getter方法（他又不会存储）那么你是不能得到想要的值的，setter方法他会将新值保存在一个叫newValue中，我们可以直接用，当然getter中也有一个newValue
 存储型属性是什么?
 存储型属性就是一个需要存储的属性，如果我们需要自定义setter和getter方法，我们得注意一下，setter方法存在两种，willSet和didSet，这两种方法我们不一定都需要实现，根据需求实现各自的方法，willSet是将要赋值的时候调用的，而didSet方法是已经赋完了值之后调用的。可以提供他的getter方法，和计算型属性不一样的是，他可以有setter方法没有getter，想想设计也是相当的合理，既然他是存储型的属性，已经存起来了，那么我们可以取得到。在willSet方法里没有必要赋值，除非你要改变新赋的值，getter方法和setter 方法不能同时出现
 */

//被观察的类
class myKVO: NSObject {
    //我们要用它代替num
    var _num:Int = 0;
    //使用 @dynamic 修饰，表示该属性的存取都由 runtime 在运行时来决定，由于 Swift 基于效率的考量默认禁止了动态派发机制，因此要加上该修饰符来开启动态派发，而OC中是默认开启动态派发机制；
    dynamic var num:Int{
        //重写num的setter方法，设置界限在0-100之内
        set {
            if (_num>100||_num<0) {
                print("超界了")
            }
            _num = newValue;
        }
        //重写num的getter方法
        get {
            return _num;
        }
    }
    
    
}

//控制器
class ViewController: UIViewController {
    //展示的文字
    @IBOutlet weak var label: UILabel!
    //增加按钮
    @IBOutlet weak var changeNum: UIButton!
    //重置按钮
    @IBOutlet weak var chongZhi: UIButton!
    //减少按钮
    @IBOutlet weak var jianShao: UIButton!
    
    //创建观察者对象
    var myKvo:myKVO = myKVO();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /*
         注册观察者的代码
         -----------参数简介----------
         *observer 观察者；
         *KeyPath 被观察的属性的名称；
         *options 被观察属性的一些配置，这里使用的，NSKeyValueObservingOption.Old代表观察旧值，NSKeyValueObservingOption.New代表观察新值,NSKeyValueObservingOption.indexes代表最初的值;
         *context 上下文，可以给kvo的回调方法传值；
         */
        //NSKeyValueObservingOption.New可以简写成.new
        self.myKvo.addObserver(self, forKeyPath: "num", options: .new, context: nil);
        
    }
    
    /*
     只要你观察的keypath发生变化就会调用这个方法
     ----------------参数简介--------------
     *keypath 被观察的属性的名称；
     *object 被观察的对象；
     *change 前后变化的值都是储存在这个字典中的；
     *context 注册观察者时，context传过来的值；
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath=="num" {

            /*
             这里使用KVO就是为了改变label上的数字
             
             *.newKey，代表新值，对应注册观察者时的NSKeyValueObservingOption.New
             *.oldKey,代表旧值，对应注册观察者时的NSKeyValueObservingOption.Old
             *.indexesKey,代表最初的值，对应注册观察者时的NSKeyValueObservingOption.indexes
             */
            if let newValue = change?[.newKey] {
                self.label.text = "当前的num值是：\(newValue)";
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //增加按钮点击事件
    @IBAction func changeNum(_ sender: UIButton) {
        self.myKvo.num = self.myKvo.num+1;
    }
    
    //重置按钮点击事件
    @IBAction func chongZhi(_ sender: UIButton) {
        self.myKvo.num = 0;
    }
    
    //减少按钮点击事件
    @IBAction func jianShao(_ sender: UIButton) {
        self.myKvo.num = self.myKvo.num-1;
    }
    
    //移除KVO
    deinit {
        self.removeObserver(self, forKeyPath: "num");
    }

}


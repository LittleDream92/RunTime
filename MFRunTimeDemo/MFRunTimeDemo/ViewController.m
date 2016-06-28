//
//  ViewController.m
//  MFRunTimeDemo
//
//  Created by Meng Fan on 16/6/28.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

/* 
 1.什么是runtime?
 
 runtime是一套底层为纯C语言的API，包含很多强大实用的C语言数据类型和C语言函数，平时我们编写的OC代码，底层都是基于runtime实现的,runtime算是OC的幕后工作者.
 
 */

/*
 2.runtime有什么作用？
 
    能够动态的增删改一个类、一个成员变量、一个方法。
 
例如 增：即创建
 OC代码：[[BDPerson alloc] init];
 runtime:objc_msgSend(objc_msgSend(“LOPerson” , “alloc”), “init”)
 
 
 */

/*
 3.常用的头文件
 
 #import <objc/runtime.h> 包含对类、成员变量、属性、方法的操作
 #import <objc/message.h> 包含消息机制
 
 */

/*
4.常用方法
 
 objc_msgSend : 给对象发送消息
 class_copyIvarList（）返回一个指向类的成员变量数组的指针
 class_copyPropertyList（）返回一个指向类的属性数组的指针
 注意：根据Apple官方runtime.h文档所示，上面两个方法返回的指针，在使用完毕之后必须free()。
 
 ivar_getName（）获取成员变量名-->C类型的字符串
 property_getName（）获取属性名-->C类型的字符串
 -------------------------------------
 typedef struct objc_method *Method;
 class_getInstanceMethod（）
 class_getClassMethod（）以上两个函数传入返回Method类型
 ---------------------------------------------------
 method_exchangeImplementations（）交换两个方法的实现
 
 主要的运用方向：
     NSCoding(归档和解档, 利用runtime遍历模型对象的所有属性)
     字典 –> 模型 (利用runtime遍历模型对象的所有属性, 根据属性名从字典中取出对应的值, 设置到模型的属性上)
     KVO(利用runtime动态产生一个类)
     用于封装框架(想怎么改就怎么改)
 
 */

#import "ViewController.h"
#import <objc/runtime.h>
#import "BDPerson.h"
#import "Student.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *mArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    /*
     5.runtime在开发中的用途
     
        5.1 动态的遍历一个类的所有成员变量，用于字典转模型,归档解档操作
     如下：*/
    
    
//    /** 查询类成员变量及类型*/
    
//    unsigned int count = 0;//无符号整型
//    /** Ivar:表示成员变量类型 */ 
//    Ivar *ivars = class_copyIvarList([BDPerson class], &count);     //获得一个指向该类成员变量的指针
//    for (int i = 0; i < count; i++) {
//        //获得Ivar
//        Ivar ivar = ivars[i];   //根据ivar获得其成员变量的名称--->C语言的字符串
//        const char *name = ivar_getName(ivar);
//        NSString *key = [NSString stringWithUTF8String:name];
//        NSLog(@"%d_%@", i, key);
//    }
//    free(ivars);
    
    
//    /** 取一个类的全部属性 */
//    unsigned int count = 0; //count初始化
//    objc_property_t *properties = class_copyPropertyList([BDPerson class], &count);//count 赋值
//    for (int i = 0; i < count; i++) {
//        //获得
//        objc_property_t property = properties[i];
//        //根据objc——property——t获得其属性的名称－－》C语言的字符串
//        const char *name = property_getName(property);
//        NSString *key = [NSString stringWithUTF8String:name];
//        NSLog(@"%d_%@", i, key);
//        
//    }
    
    
//    /*   */
//    self.mArray = [NSMutableArray array];
//    
//    [self.mArray addObject:@"Json"];
//    [self.mArray addObject:@"Rose"];
//    [self.mArray addObject:nil];  //由于向数组中添加了nil，数组崩溃 ,但是，我们给nsmutableArray写了个类目，做一个替换，因此就不会崩溃啦， 我觉得这个好，因为项目中的崩溃有一大部分原因就是array有关的.
//    
//    NSLog(@"%@", self.mArray);
    
    
    
}


 /** 查询类成员变量及类型*/
/**
 *  必备常识:
 *  Ivar : 成员变量    如果要是动态创建/修改/查看属性，可以使用Ivar
 *  Method : 成员方法  如果要是动态创建/修改/查看方法，可以使用Method
 *  下面的例子教大家一些runtime简单的 查看类中属性和方法以及动态添加属性和方法和修改属性.
 */

/**
 *  通过类的名字来获取类里面包含的所有属性
 *
 *  @param className 类名(egs:UIView)
 */
- (void)getIvarsNameListWithClassName:(NSString *)className
{
    //通过类的名字获取到类(egs:通过"学生"这个类的名字找到"学生"这个类)
    Class ClassName = NSClassFromString(className);
    
    //定义一个变量来存放遍历出来类里面属性的个数
    unsigned int outConut = 0;
    //查取类里面所有的属性
    Ivar * vars = class_copyIvarList([ClassName class], &outConut);
    //打印类里面有多少个属性
    NSLog(@"%d",outConut);
    
    //遍历类里面所有的属性 和 属性类型
    for (int i = 0; i < outConut; i ++) {
        //获取类里面属性的名字(将IVar变量转化为字符串)
        const char * ivarName = ivar_getName(vars[i]);
        //获取类里面属性的类型(获取IVar的类型)
        const char * ivarType = ivar_getTypeEncoding(vars[i]);
        //打印属性的名字和类型
        printf("属性名字:%s 属性类型:%s\n",ivarName,ivarType);
    }
}




/** 查询类方法名及类型 */
/**
 *  通过类的名字,查看类中所有的方法
 *
 *  @param className 类的名字(egs:UIView)
 */
- (void)getMethodNameListWithClassName:(NSString *)className
{
    //如果想添加方法直接调用就行了(只需要改一下类)
    //添加方法
//    [self addMethod];
    /**
     * class_copyMethodList：获取所有方法
     * method_getName：读取一个Method类型的变量，输出我们在上层中很熟悉的SEL
     *
     */
    
    //通过类的名字,获取到类
    Class ClassName = NSClassFromString(className);
    //定义一个变量来存放遍历出来类里面属性的个数
    unsigned int count = 0;
    //查取类里面所有的属性
    Method * method = class_copyMethodList(ClassName, &count);
    //遍历类里面所有的属性 和 属性类型
    for (int i = 0; i < count; i ++) {
        //获取类里面方法的名字
        SEL methodName = method_getName(method[i]);
        //获取类里面方法的类型
        const char * methodType = method_copyReturnType(method[i]);
        NSLog(@"方法名字:%@,方法类型:%s",NSStringFromSelector(methodName),methodType);
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////归档解档需要遵守<NSCoding>协议，实现以下两个方法
//- (void)encodeWithCoder:(NSCoder *)aCoder {
//    //归档存储自定义对象
//    unsigned int count = 0;
//    //获得指向该类所有属性的指针
//    objc_property_t *properties =     class_copyPropertyList([BDPerson class], &count);
//    for (int i =0; i < count; i ++) {
//        //获得
//        objc_property_t property = properties[i];        //根据objc_property_t获得其属性的名称--->C语言的字符串
//        const char *name = property_getName(property);
//        NSString *key = [NSString   stringWithUTF8String:name];
//        //      编码每个属性,利用kVC取出每个属性对应的数值
//        [aCoder encodeObject:[self valueForKeyPath:key] forKey:key];
//    }
//
//}
//
//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    
//    self = [super initWithCoder:aDecoder];
//    
//    if (self) {
//        //归档存储自定义对象
//        unsigned int count = 0;
//        //获得指向该类所有属性的指针
//        objc_property_t *properties = class_copyPropertyList([BDPerson class], &count);
//        for (int i =0; i < count; i ++) {
//            objc_property_t property = properties[i];        //根据objc_property_t获得其属性的名称--->C语言的字符串
//            const char *name = property_getName(property);
//            NSString *key = [NSString stringWithUTF8String:name];        //解码每个属性,利用kVC取出每个属性对应的数值
//            [self setValue:[aDecoder decodeObjectForKey:key] forKeyPath:key];
//        }
//    }
//    return self;
//    
//}


@end

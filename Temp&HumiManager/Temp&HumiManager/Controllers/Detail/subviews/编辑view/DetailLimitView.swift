//
//  DetailLimitView.swift
//  Temp&HumiManager
//
//  Created by terry on 2018/3/21.
//  Copyright © 2018年 terry. All rights reserved.
//

import UIKit

/*
 如果Swift类想要被OC发现，必须继承自NSObject并且使用public标记，并且该类中想要被OC访问的方法也必须使用public标记，具体知识可以去看Swift的访问控制
 原因：Swift的代码对于OC来说是作为一个module存在的
 */

public class DetailLimitView: UIView {

    public lazy var imvHead : UIImageView = {
        let imv = UIImageView();
        self.addSubview(imv);
        return imv;
    } ();

    public lazy var labUnit : UILabel = {
        let lab = UILabel();
        lab.textAlignment = .center;
        self.addSubview(lab);
        return lab;
    } ();

    public lazy var tfLess : MyValueTextfield = {
        let tf = MyValueTextfield();
        tf.labValue.text = "<";
        tf.labValue.textColor = UIColor.white;
        self.addSubview(tf);
        return tf;
    } ();

    @objc public lazy var tfMore : MyValueTextfield = {
        let tf = MyValueTextfield();
        tf.labValue.text = ">";
        tf.oppisite = true;
        tf.labValue.textColor = UIColor.white;
        self.addSubview(tf);
        return tf;
    } ();

    var tfLess_textField : UITextField? {
        get {
            return self.tfLess.textField;
        }
    }

    var tfMore_textField : UITextField? {
        get {
            return self.tfMore.textField;
        }
    }







    override public func layoutSubviews() {
        super.layoutSubviews();

        let distance = Fit_X(value: 5.0);
        if imvHead.image != nil {
            let h = self.frame.size.height - distance*2.0;
            let w = ((imvHead.image?.size.width)!/(imvHead.image?.size.height)!)*h;
            imvHead.frame = CGRect.init(x: distance, y: distance, width: w, height: h);
        }

        labUnit.frame = CGRect.init(x: imvHead.frame.origin.x + Fit_X(value: 15.0) + distance, y: imvHead.frame.origin.y, width: Fit_X(value: 50.0), height: imvHead.frame.size.height);

        let wTf = (self.frame.size.width - labUnit.frame.origin.x - labUnit.frame.size.width - distance*3.0)/2.0;
        tfLess.frame = CGRect.init(x: labUnit.frame.origin.x + labUnit.frame.size.width + distance, y: labUnit.frame.origin.y, width: wTf, height: labUnit.bounds.size.height);

        tfMore.frame = CGRect.init(x: tfLess.frame.origin.x + tfLess.frame.size.width + distance, y: labUnit.frame.origin.y, width: wTf, height: labUnit.bounds.size.height);
    }

}

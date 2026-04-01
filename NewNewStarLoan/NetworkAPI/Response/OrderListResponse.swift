import Foundation

struct OrderListResponse: Codable {
    let hundred: String      // 状态码
    let seats: String       // 状态信息
    let middle: OrderMiddle // 数据主体
}

struct OrderMiddle: Codable {
    let dog: [OrderItem]    // 订单列表
    let successful: Int     // 成功标识
}

struct OrderItem: Codable {
    let visiting: Int       // 订单ID
    let foreground: Int     // 产品ID
    let moving: Int         // 订单状态
    let cratered: String    // 产品名称
    let dairy: String       // 跳转链接
    let vomiting: String    // 按钮文案
    let orderStatusDesc: String  // 订单状态描述
    let loanTime: String    // 借款时间
    let repayTime: String   // 还款时间
    let shrieking: String   // 借款期限
    let herat: String       // 订单唯一标识
    let statusTextDesc: String   // 状态描述文本
    let orderAmount: String      // 订单金额
    let date: String        // 日期
    let statusTextDescButton: String  // 状态按钮文本
    let outlined: Int       // 订单类型标识
    let liveries: OrderLiveries  // 重构后的订单详情
    let noticeText: String  // 通知文本
    let isLoan: Int        // 是否已放款
    let lots: Int          // 附加状态
    let buttonUrl: String   // 按钮跳转链接
    let moneyText: String   // 金额文本描述
    let watched: String     // logo链接
    let loanText: String    // 借款文本描述
    
    // 以下字段为兼容性保留
    let dateText: String
    let older: String
    let assured: String
    let dateValue: String
    let overdueDays: Int
}

struct OrderLiveries: Codable {
    let visiting: Int       // 订单ID
    let foreground: Int     // 产品ID
    let watched: String     // logo链接
    let cratered: String    // 产品名称
    let dreams: String      // 右上角订单状态文案
    let artists: String     // 金额描述
    let few: String        // 金额
    let sight: String      // 日期文案
    let enjoyed: String    // 日期
    let colour: String     // 期限文案
    let sunset: String     // 期限
    let wise: String       // 按钮文案，为空时不显示按钮
    let shoulder: String   // 订单描述文案
    let heartily: Int      // 类型：1逾期 2还款中 3未申请 4审核中 5已完成
    let dairy: String      // 点击跳转链接(h5或原生)
    let lots: Int         // 附加状态
}

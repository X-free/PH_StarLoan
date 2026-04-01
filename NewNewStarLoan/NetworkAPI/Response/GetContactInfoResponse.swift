
import Foundation

struct GetContactInfoResponse: Codable {
  let seats: String
  let hundred: String
  let middle: MiddleInfo
  
  struct MiddleInfo: Codable {
    let intellectual: IntellectualInfo
    
    struct IntellectualInfo: Codable {
      let dog: [ContactItem]
      let inexplicable: String
      
      struct ContactItem: Codable {
        let comparatively: String  // 选中的关系key
        let satisfy: String        // 联系人标题
        let delight: [RelationItem] // 关系选项列表
        let engaged: String        // 关系选择标题
        let bad: String           // 联系人姓名
        let slouched: String      // 联系人电话
        let hobby: String         // 当前item标识
        let sandwich: String      // 关系选择提示文案
        let navvies: String       // 联系信息标题
        let wretched: String      // 联系信息提示文案
        let relationText: String  // 关系文本
        
        struct RelationItem: Codable {
          let bad: String         // 关系名称
          let mountainside: String // 关系ID
        }
      }
    }
  }
}

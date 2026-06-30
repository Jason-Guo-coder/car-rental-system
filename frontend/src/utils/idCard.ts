/** 身份证号解析工具：从 18 位身份证号提取出生日期、年龄、性别 */

export interface IdCardInfo {
  birthDate: string // YYYY-MM-DD
  age: number
  gender: '男' | '女'
}

/** 校验是否为 18 位身份证号（基础格式，不做校验码运算） */
export function isValidIdCard(id: string): boolean {
  return /^\d{17}[\dXx]$/.test(id)
}

/** 解析身份证号；非法返回 null */
export function parseIdCard(id: string): IdCardInfo | null {
  if (!isValidIdCard(id)) return null

  const year = Number(id.slice(6, 10))
  const month = Number(id.slice(10, 12))
  const day = Number(id.slice(12, 14))
  if (month < 1 || month > 12 || day < 1 || day > 31) return null

  const birthDate = `${year}-${String(month).padStart(2, '0')}-${String(day).padStart(2, '0')}`

  // 年龄：以当前日期计算
  const now = new Date()
  let age = now.getFullYear() - year
  if (now.getMonth() + 1 < month || (now.getMonth() + 1 === month && now.getDate() < day)) age--

  // 性别：第 17 位奇数为男，偶数为女
  const gender: '男' | '女' = Number(id.charAt(16)) % 2 === 1 ? '男' : '女'

  return { birthDate, age, gender }
}

// ===== 数据模型与 Mock 数据 =====

export enum CrowdLevel {
  Free = 0,    // 畅通
  Busy = 1,    // 较挤
  Crowded = 2  // 拥挤
}

export interface Dish {
  id: number;
  name: string;
  price: number;
  emoji: string;
  tags: string[];
  sales: number;
  desc: string;
  soldOut: boolean;
}

export interface WindowInfo {
  id: number;
  name: string;
  tags: string;
  queue: number; // 排队人数
  dishes: Dish[];
}

export interface Canteen {
  id: number;
  name: string;
  distance: string;
  wait: number; // 预计等待分钟
  level: CrowdLevel;
  openTime: string;
  windows: WindowInfo[];
}

export interface PointRecord {
  id: number;
  time: string;
  title: string;
  points: number;
}

export interface Coupon {
  id: number;
  amount: number;
  threshold: number;
  title: string;
  expire: string;
}

export interface OrderDish {
  name: string;
  price: number;
  qty: number;
}

export interface OrderInfo {
  pickupNo: string;
  canteenName: string;
  windowName: string;
  slot: string;
  total: number;
  items: OrderDish[];
  finished: boolean;
}

export function levelText(level: CrowdLevel): string {
  if (level === CrowdLevel.Free) {
    return '畅通';
  } else if (level === CrowdLevel.Busy) {
    return '较挤';
  }
  return '拥挤';
}

export function levelColor(level: CrowdLevel): string {
  if (level === CrowdLevel.Free) {
    return '#2BB673';
  } else if (level === CrowdLevel.Busy) {
    return '#F59B23';
  }
  return '#F04E4E';
}

export function levelBg(level: CrowdLevel): string {
  if (level === CrowdLevel.Free) {
    return '#E8F8F0';
  } else if (level === CrowdLevel.Busy) {
    return '#FDF3E3';
  }
  return '#FDEAEA';
}

export function findCanteen(id: number): Canteen {
  for (let i = 0; i < CANTEENS.length; i++) {
    if (CANTEENS[i].id === id) {
      return CANTEENS[i];
    }
  }
  return CANTEENS[0];
}

export const CANTEENS: Canteen[] = [
  {
    id: 1,
    name: '第一食堂 · 梅园',
    distance: '距你 120m',
    wait: 8,
    level: CrowdLevel.Free,
    openTime: '06:30 - 20:00',
    windows: [
      {
        id: 101,
        name: '川湘风味',
        tags: '微辣 · 下饭',
        queue: 4,
        dishes: [
          { id: 1001, name: '鱼香肉丝盖饭', price: 12.0, emoji: '🍚', tags: ['微辣', '招牌'], sales: 326, desc: '酸甜微辣，配时蔬', soldOut: false },
          { id: 1002, name: '麻婆豆腐饭', price: 10.0, emoji: '🌶️', tags: ['麻辣', '素食友好'], sales: 215, desc: '嫩豆腐 + 牛肉末', soldOut: false },
          { id: 1003, name: '小炒黄牛肉', price: 16.0, emoji: '🥩', tags: ['辣', '高蛋白'], sales: 168, desc: '湘菜现炒', soldOut: false }
        ]
      },
      {
        id: 102,
        name: '江南小炒',
        tags: '清淡 · 少油',
        queue: 2,
        dishes: [
          { id: 1101, name: '番茄炒蛋套餐', price: 9.0, emoji: '🍅', tags: ['不辣', '家常'], sales: 402, desc: '一荤两素一汤', soldOut: false },
          { id: 1102, name: '清蒸鲈鱼饭', price: 18.0, emoji: '🐟', tags: ['高蛋白', '低脂'], sales: 96, desc: '每日限量', soldOut: false },
          { id: 1103, name: '蒜蓉西兰花', price: 6.0, emoji: '🥦', tags: ['素食'], sales: 233, desc: '清爽少油', soldOut: false }
        ]
      },
      {
        id: 103,
        name: '面食档',
        tags: '现煮 · 快捷',
        queue: 6,
        dishes: [
          { id: 1201, name: '牛肉拉面', price: 11.0, emoji: '🍜', tags: ['招牌', '微辣'], sales: 518, desc: '手工拉面', soldOut: false },
          { id: 1202, name: '葱油拌面', price: 7.0, emoji: '🍝', tags: ['素食'], sales: 287, desc: '上海风味', soldOut: false },
          { id: 1203, name: '酸汤水饺', price: 10.0, emoji: '🥟', tags: ['微酸'], sales: 154, desc: '12 只一份', soldOut: true }
        ]
      }
    ]
  },
  {
    id: 2,
    name: '第二食堂 · 兰苑',
    distance: '距你 350m',
    wait: 18,
    level: CrowdLevel.Busy,
    openTime: '06:30 - 21:00',
    windows: [
      {
        id: 201,
        name: '黄焖鸡米饭',
        tags: '酱香 · 浓郁',
        queue: 12,
        dishes: [
          { id: 2001, name: '黄焖鸡套餐', price: 13.0, emoji: '🍗', tags: ['招牌'], sales: 612, desc: '鸡腿肉 + 金针菇', soldOut: false },
          { id: 2002, name: '黄焖排骨', price: 15.0, emoji: '🍖', tags: ['新品'], sales: 134, desc: '软烂脱骨', soldOut: false },
          { id: 2003, name: '米饭加量', price: 1.0, emoji: '🍚', tags: ['适量取用'], sales: 980, desc: '吃多少点多少', soldOut: false }
        ]
      },
      {
        id: 202,
        name: '轻食沙拉',
        tags: '减脂 · 低卡',
        queue: 3,
        dishes: [
          { id: 2101, name: '鸡胸肉藜麦碗', price: 16.0, emoji: '🥗', tags: ['低脂', '高蛋白'], sales: 245, desc: '约 420 千卡', soldOut: false },
          { id: 2102, name: '蔬菜鸡蛋卷', price: 8.0, emoji: '🌯', tags: ['早餐'], sales: 176, desc: '全麦饼皮', soldOut: false },
          { id: 2103, name: '无糖豆浆', price: 3.0, emoji: '🥛', tags: ['无糖'], sales: 356, desc: '现磨', soldOut: false }
        ]
      },
      {
        id: 203,
        name: '麻辣香锅',
        tags: '自选 · 称重',
        queue: 9,
        dishes: [
          { id: 2201, name: '香锅单人餐', price: 17.0, emoji: '🥘', tags: ['麻辣'], sales: 198, desc: '荤素搭配 12 种', soldOut: false },
          { id: 2202, name: '时蔬拼盘', price: 8.0, emoji: '🥬', tags: ['素食'], sales: 142, desc: '4 种新鲜蔬菜', soldOut: false }
        ]
      }
    ]
  },
  {
    id: 3,
    name: '清真食堂',
    distance: '距你 520m',
    wait: 25,
    level: CrowdLevel.Crowded,
    openTime: '07:00 - 20:30',
    windows: [
      {
        id: 301,
        name: '清真牛肉拉面',
        tags: '招牌 · 现拉',
        queue: 15,
        dishes: [
          { id: 3001, name: '招牌牛肉拉面', price: 12.0, emoji: '🍜', tags: ['招牌'], sales: 723, desc: '汤头浓郁', soldOut: false },
          { id: 3002, name: '牛肉泡馍', price: 14.0, emoji: '🥣', tags: ['暖胃'], sales: 188, desc: '西北风味', soldOut: false }
        ]
      },
      {
        id: 302,
        name: '新疆风味',
        tags: '烧烤 · 抓饭',
        queue: 11,
        dishes: [
          { id: 3101, name: '羊肉抓饭', price: 15.0, emoji: '🍛', tags: ['招牌'], sales: 264, desc: '胡萝卜 + 羊腿肉', soldOut: false },
          { id: 3102, name: '烤羊肉串', price: 8.0, emoji: '🍢', tags: ['3 串'], sales: 397, desc: '现烤', soldOut: false }
        ]
      },
      {
        id: 303,
        name: '盖浇饭',
        tags: '出餐快',
        queue: 7,
        dishes: [
          { id: 3201, name: '土豆烧牛肉饭', price: 12.0, emoji: '🥔', tags: ['不辣'], sales: 209, desc: '绵密土豆', soldOut: false },
          { id: 3202, name: '青椒炒蛋饭', price: 9.0, emoji: '🫑', tags: ['家常'], sales: 156, desc: '锅气十足', soldOut: false }
        ]
      }
    ]
  }
];

// 首页错峰曲线（百分比为该时段拥挤程度）
export const PEAK_BARS: BarPoint[] = [
  { time: '10:30', value: 22, now: false },
  { time: '11:00', value: 48, now: false },
  { time: '11:30', value: 76, now: false },
  { time: '12:00', value: 96, now: true },
  { time: '12:30', value: 70, now: false },
  { time: '13:00', value: 34, now: false }
];

export interface BarPoint {
  time: string;
  value: number;
  now: boolean;
}

export const COUPONS: Coupon[] = [
  { id: 1, amount: 5, threshold: 15, title: '食堂通用券', expire: '9月30日到期' },
  { id: 2, amount: 3, threshold: 10, title: '早餐专用券', expire: '10月10日到期' },
  { id: 3, amount: 8, threshold: 25, title: '轻食窗口券', expire: '10月15日到期' }
];

export const RANK_LIST: RankItem[] = [
  { name: '李同学', days: 42 },
  { name: '王同学', days: 38 },
  { name: '陈同学', days: 31 },
  { name: '我', days: 5, self: true },
  { name: '赵同学', days: 4 }
];

export interface RankItem {
  name: string;
  days: number;
  self?: boolean;
}

export const INITIAL_RECORDS: PointRecord[] = [
  { id: 3, time: '今天 08:12', title: '错峰早餐奖励', points: 5 },
  { id: 2, time: '昨天 18:40', title: '光盘行动奖励', points: 20 },
  { id: 1, time: '昨天 12:05', title: '自带餐具奖励', points: 3 }
];

// 光盘页今日任务
export const DAILY_TASKS: TaskDef[] = [
  { id: 'offpeak', title: '错峰就餐', desc: '在 11:00 前或 13:00 后下单', points: 5, emoji: '⏰' },
  { id: 'utensil', title: '自带餐具', desc: '出示自带餐具打卡', points: 3, emoji: '🥢' },
  { id: 'moderate', title: '适量点餐', desc: '本餐无剩余并完成光盘', points: 5, emoji: '🍽️' }
];

export interface TaskDef {
  id: string;
  title: string;
  desc: string;
  points: number;
  emoji: string;
}

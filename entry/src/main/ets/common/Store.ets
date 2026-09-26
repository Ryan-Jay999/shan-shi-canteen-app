// ===== 全局状态（购物车 / 积分 / 订单）=====

import { Dish, INITIAL_RECORDS, OrderInfo, PointRecord } from './Model';

@Observed
export class CartItem {
  dishId: number;
  name: string;
  price: number;
  qty: number;
  windowName: string;
  canteenName: string;

  constructor(dishId: number, name: string, price: number, qty: number,
              windowName: string, canteenName: string) {
    this.dishId = dishId;
    this.name = name;
    this.price = price;
    this.qty = qty;
    this.windowName = windowName;
    this.canteenName = canteenName;
  }
}

@Observed
export class CartManager {
  items: CartItem[] = [];

  add(dish: Dish, windowName: string, canteenName: string): void {
    let found: CartItem | null = null;
    for (let i = 0; i < this.items.length; i++) {
      if (this.items[i].dishId === dish.id) {
        found = this.items[i];
        break;
      }
    }
    if (found !== null) {
      found.qty += 1;
    } else {
      this.items.push(new CartItem(dish.id, dish.name, dish.price, 1, windowName, canteenName));
    }
    // 整体重新赋值以触发 @Observed 刷新
    this.items = this.items.slice();
  }

  changeQty(dishId: number, delta: number): void {
    const next: CartItem[] = [];
    for (let i = 0; i < this.items.length; i++) {
      const it = this.items[i];
      if (it.dishId === dishId) {
        it.qty += delta;
      }
      if (it.qty > 0) {
        next.push(it);
      }
    }
    this.items = next;
  }

  clear(): void {
    this.items = [];
  }

  qtyOf(dishId: number): number {
    for (let i = 0; i < this.items.length; i++) {
      if (this.items[i].dishId === dishId) {
        return this.items[i].qty;
      }
    }
    return 0;
  }

  count(): number {
    let n = 0;
    this.items.forEach((it: CartItem) => {
      n += it.qty;
    });
    return n;
  }

  total(): number {
    let t = 0;
    this.items.forEach((it: CartItem) => {
      t += it.qty * it.price;
    });
    return t;
  }
}

export class Store {
  private static recordId: number = 100;

  static init(): void {
    if (AppStorage.has('cart')) {
      return;
    }
    AppStorage.setOrCreate('cart', new CartManager());
    AppStorage.setOrCreate('points', 320);
    AppStorage.setOrCreate('records', INITIAL_RECORDS.slice());
    AppStorage.setOrCreate('streak', 5);
    AppStorage.setOrCreate('plateDone', false);
    AppStorage.setOrCreate('doneTasks', [] as string[]);
    AppStorage.setOrCreate('mainTabIndex', 0);
    AppStorage.setOrCreate('lastOrder', null as OrderInfo | null);
    AppStorage.setOrCreate('cardValue', '¥86.50');
    AppStorage.setOrCreate('address', '梅园 3 号楼');
    AppStorage.setOrCreate('taste', '微辣 · 少油');
  }

  static addPoints(points: number, title: string): void {
    const cur = AppStorage.get<number>('points');
    AppStorage.setOrCreate('points', (cur ?? 0) + points);
    Store.recordId += 1;
    const records = AppStorage.get<PointRecord[]>('records') ?? [];
    const rec: PointRecord = {
      id: Store.recordId,
      time: '刚刚',
      title: title,
      points: points
    };
    AppStorage.setOrCreate('records', [rec].concat(records));
  }

  // 领取今日任务积分，成功返回 true
  static claimTask(taskId: string, points: number, title: string): boolean {
    const done = AppStorage.get<string[]>('doneTasks') ?? [];
    for (let i = 0; i < done.length; i++) {
      if (done[i] === taskId) {
        return false;
      }
    }
    const next = done.slice();
    next.push(taskId);
    AppStorage.setOrCreate('doneTasks', next);
    Store.addPoints(points, title);
    return true;
  }

  static isTaskDone(taskId: string): boolean {
    const done = AppStorage.get<string[]>('doneTasks') ?? [];
    for (let i = 0; i < done.length; i++) {
      if (done[i] === taskId) {
        return true;
      }
    }
    return false;
  }
}

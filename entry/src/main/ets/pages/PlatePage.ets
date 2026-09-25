import { promptAction, router } from '@kit.ArkUI';
import { DAILY_TASKS, RANK_LIST, RankItem, TaskDef } from '../common/Model';
import { Store } from '../common/Store';

@Component
export struct PlatePage {
  @StorageLink('points') points: number = 0;
  @StorageLink('streak') streak: number = 5;
  @StorageLink('plateDone') plateDone: boolean = false;
  @StorageLink('doneTasks') doneTasks: string[] = [];
  @State recognizing: boolean = false;
  @State showSuccess: boolean = false;
  private week: number[] = [0, 1, 2, 3, 4, 5, 6];

  aboutToAppear(): void {
    Store.init();
  }

  private startRecognize(): void {
    if (this.plateDone) {
      promptAction.showToast({ message: '今日已经光盘打卡啦，明天继续！' });
      return;
    }
    this.recognizing = true;
    // 模拟 AI 识别耗时（真实场景接入图像识别 Kit）
    setTimeout(() => {
      this.recognizing = false;
      this.plateDone = true;
      this.streak = this.streak + 1;
      Store.addPoints(20, '光盘行动奖励');
      this.showSuccess = true;
    }, 1600);
  }

  private claim(task: TaskDef): void {
    const ok = Store.claimTask(task.id, task.points, task.title);
    if (ok) {
      promptAction.showToast({ message: `已领取 +${task.points} 积分` });
    }
  }

  build() {
    Stack() {
      Column() {
        Scroll() {
          Column({ space: 14 }) {
            // 积分头部
            Column({ space: 8 }) {
              Text('光盘助手')
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
                .width('100%')
                .margin({ top: 48 })
              Row() {
                Column({ space: 2 }) {
                  Text(this.points.toString())
                    .fontSize(34)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(Color.White)
                  Text('我的节约积分')
                    .fontSize(12)
                    .fontColor('#FFE8DD')
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)
                Text('积分明细 ›')
                  .fontSize(12)
                  .fontColor('#B45309')
                  .backgroundColor('#FFF7E6')
                  .padding({ left: 10, right: 10, top: 6, bottom: 6 })
                  .borderRadius(14)
                  .onClick(() => {
                    router.pushUrl({ url: 'pages/PointsDetailPage' });
                  })
              }
              .width('100%')
              .margin({ top: 8 })
            }
            .width('100%')
            .padding({ left: 16, right: 16, bottom: 18 })
            .linearGradient({ angle: 140, colors: [['#48C78E', 0.0], ['#2BB673', 1.0]] })

            Column({ space: 14 }) {
              // 连续打卡
              Column({ space: 12 }) {
                Row() {
                  Text(`连续光盘 ${this.streak} 天`)
                    .fontSize(15)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#222222')
                    .layoutWeight(1)
                  Text('坚持就是节约小达人 🌱')
                    .fontSize(11)
                    .fontColor('#999999')
                }
                .width('100%')
                Row() {
                  ForEach(this.week, (i: number) => {
                    Column({ space: 4 }) {
                      Text(i < this.streak || (i === 6 && this.plateDone) ? '✓' : '')
                        .fontSize(11)
                        .fontColor(Color.White)
                        .width(28)
                        .height(28)
                        .textAlign(TextAlign.Center)
                        .borderRadius(14)
                        .backgroundColor(i < this.streak || (i === 6 && this.plateDone) ? '#2BB673' : '#E5E7EB')
                      Text(['一', '二', '三', '四', '五', '六', '今'][i])
                        .fontSize(10)
                        .fontColor(i === 6 ? '#2BB673' : '#999999')
                    }
                    .layoutWeight(1)
                  }, (i: number) => i.toString())
                }
                .width('100%')
              }
              .width('100%')
              .padding(14)
              .backgroundColor(Color.White)
              .borderRadius(14)

              // 拍照打卡
              Column({ space: 10 }) {
                Text('餐后拍照，AI 识别光盘')
                  .fontSize(15)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#222222')
                  .width('100%')
                Stack() {
                  Column({ space: 10 }) {
                    Text(this.plateDone ? '✅' : '📷')
                      .fontSize(46)
                    Text(this.plateDone ? '今日已完成光盘打卡' : '拍摄餐后餐盘')
                      .fontSize(14)
                      .fontColor(this.plateDone ? '#2BB673' : '#555555')
                    Text(this.plateDone ? '+20 积分已到账' : '识别为光盘可获得 20 积分')
                      .fontSize(12)
                      .fontColor('#999999')
                  }
                  .justifyContent(FlexAlign.Center)
                }
                .width('100%')
                .height(170)
                .backgroundColor(this.plateDone ? '#EAF8F1' : '#F7F8FA')
                .borderRadius(12)
                .onClick(() => {
                  this.startRecognize();
                })
              }
              .width('100%')
              .padding(14)
              .backgroundColor(Color.White)
              .borderRadius(14)

              // 今日任务
              Column({ space: 12 }) {
                Text('今日节约任务')
                  .fontSize(15)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#222222')
                  .width('100%')
                ForEach(DAILY_TASKS, (t: TaskDef) => {
                  Row({ space: 10 }) {
                    Text(t.emoji)
                      .fontSize(22)
                      .width(40)
                      .height(40)
                      .textAlign(TextAlign.Center)
                      .backgroundColor('#F7F8FA')
                      .borderRadius(20)
                    Column({ space: 3 }) {
                      Text(t.title)
                        .fontSize(14)
                        .fontWeight(FontWeight.Medium)
                        .fontColor('#222222')
                      Text(t.desc)
                        .fontSize(11)
                        .fontColor('#999999')
                    }
                    .alignItems(HorizontalAlign.Start)
                    .layoutWeight(1)
                    if (Store.isTaskDone(t.id)) {
                      Text('已领取')
                        .fontSize(12)
                        .fontColor('#999999')
                        .backgroundColor('#F2F3F5')
                        .padding({ left: 10, right: 10, top: 6, bottom: 6 })
                        .borderRadius(14)
                    } else {
                      Text(`+${t.points}`)
                        .fontSize(12)
                        .fontColor('#2BB673')
                        .backgroundColor('#E8F8F0')
                        .padding({ left: 10, right: 10, top: 6, bottom: 6 })
                        .borderRadius(14)
                        .onClick(() => {
                          this.claim(t);
                        })
                    }
                  }
                  .width('100%')
                }, (t: TaskDef) => t.id)
              }
              .width('100%')
              .padding(14)
              .backgroundColor(Color.White)
              .borderRadius(14)

              // 节约榜
              Column({ space: 10 }) {
                Row() {
                  Text('光盘节约榜')
                    .fontSize(15)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#222222')
                    .layoutWeight(1)
                  Text('本月')
                    .fontSize(11)
                    .fontColor('#999999')
                }
                .width('100%')
                ForEach(RANK_LIST, (r: RankItem, idx: number) => {
                  Row({ space: 10 }) {
                    Text(['🥇', '🥈', '🥉', '4', '5'][idx])
                      .fontSize(14)
                      .width(24)
                      .textAlign(TextAlign.Center)
                    Text(r.name)
                      .fontSize(13)
                      .fontColor(r.self === true ? '#2BB673' : '#333333')
                      .fontWeight(r.self === true ? FontWeight.Bold : FontWeight.Normal)
                      .layoutWeight(1)
                    Text(`${r.days} 天`)
                      .fontSize(13)
                      .fontColor('#666666')
                  }
                  .width('100%')
                  .padding({ top: 6, bottom: 6 })
                }, (r: RankItem, idx: number) => r.name + idx.toString())
              }
              .width('100%')
              .padding(14)
              .backgroundColor(Color.White)
              .borderRadius(14)
              .margin({ bottom: 12 })
            }
            .width('100%')
            .padding(16)
          }
          .width('100%')
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .backgroundColor('#F5F6F8')
      }
      .width('100%')
      .height('100%')

      // AI 识别中遮罩
      if (this.recognizing) {
        Column({ space: 14 }) {
          Text('🔍')
            .fontSize(42)
          Text('AI 识别中…')
            .fontSize(16)
            .fontColor(Color.White)
          Text('正在分析餐盒剩余食物')
            .fontSize(12)
            .fontColor('#DDDDDD')
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .backgroundColor('rgba(0,0,0,0.55)')
      }

      // 打卡成功弹层
      if (this.showSuccess) {
        Column({ space: 16 }) {
          Column({ space: 8 }) {
            Text('🎉')
              .fontSize(48)
            Text('光盘成功！')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor('#222222')
            Text('珍惜粮食，感谢你的坚持')
              .fontSize(13)
              .fontColor('#777777')
            Text('+20 积分')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#2BB673')
              .margin({ top: 4 })
          }
          Button('开心收下')
            .fontSize(15)
            .fontColor(Color.White)
            .backgroundColor('#2BB673')
            .width(200)
            .height(44)
            .borderRadius(22)
            .onClick(() => {
              this.showSuccess = false;
            })
        }
        .width('82%')
        .padding({ top: 30, bottom: 26, left: 20, right: 20 })
        .backgroundColor(Color.White)
        .borderRadius(18)
      }
    }
    .width('100%')
    .height('100%')
  }
}

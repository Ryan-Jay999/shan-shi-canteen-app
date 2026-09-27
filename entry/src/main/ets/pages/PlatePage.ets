import { promptAction, router } from '@kit.ArkUI';
import { DAILY_TASKS, RANK_LIST, RankItem, TaskDef } from '../common/Model';
import { Store } from '../common/Store';
import { DemoBadge, DemoNotice } from '../common/Widgets';

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
    // 演示：此处模拟识别耗时，当前版本不会真实调用相机与图像识别能力
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
      promptAction.showToast({ message: `已领取 +${task.points} 积分（演示数据）` });
    }
  }

  private rankLabel(idx: number): string {
    if (idx === 0) {
      return '🥇';
    } else if (idx === 1) {
      return '🥈';
    } else if (idx === 2) {
      return '🥉';
    }
    return (idx + 1).toString();
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
                    .fontColor($r('app.color.c_on_brand_sub'))
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)
                Text('积分明细 ›')
                  .fontSize(12)
                  .fontColor($r('app.color.c_brand_text'))
                  .backgroundColor($r('app.color.c_warm_bg'))
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
            .linearGradient({ angle: 140, colors: [['#2E9A66', 0.0], ['#177A4C', 1.0]] })

            Column({ space: 14 }) {
              DemoNotice({ text: '演示版：积分、打卡记录、任务与排行榜均为演示数据，不接入真实校园系统。' })

              // 连续打卡
              Column({ space: 12 }) {
                Row() {
                  Text(`连续光盘 ${this.streak} 天`)
                    .fontSize(15)
                    .fontWeight(FontWeight.Bold)
                    .fontColor($r('app.color.c_text_primary'))
                    .layoutWeight(1)
                  Text('坚持就是节约小达人 🌱')
                    .fontSize(11)
                    .fontColor($r('app.color.c_text_tertiary'))
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
                        .backgroundColor(i < this.streak || (i === 6 && this.plateDone)
                          ? '#177A4C'
                          : $r('app.color.c_disabled_bg2'))
                      Text(['一', '二', '三', '四', '五', '六', '今'][i])
                        .fontSize(10)
                        .fontColor(i === 6 ? $r('app.color.c_success') : $r('app.color.c_text_tertiary'))
                    }
                    .layoutWeight(1)
                  }, (i: number) => i.toString())
                }
                .width('100%')
              }
              .width('100%')
              .padding(14)
              .backgroundColor($r('app.color.c_card_bg'))
              .borderRadius(14)

              // 拍照打卡
              Column({ space: 10 }) {
                Row({ space: 8 }) {
                  Text('餐后拍照识别（演示）')
                    .fontSize(15)
                    .fontWeight(FontWeight.Bold)
                    .fontColor($r('app.color.c_text_primary'))
                  DemoBadge()
                }
                .width('100%')
                Stack() {
                  Column({ space: 10 }) {
                    Text(this.plateDone ? '✅' : '📷')
                      .fontSize(46)
                    Text(this.plateDone ? '今日已完成光盘打卡' : '拍摄餐后餐盘（演示）')
                      .fontSize(14)
                      .fontColor(this.plateDone ? $r('app.color.c_success') : $r('app.color.c_text_secondary'))
                    Text(this.plateDone ? '+20 积分已到账（演示）' : '演示流程，不会调用相机；识别为光盘可得 20 积分')
                      .fontSize(12)
                      .fontColor($r('app.color.c_text_tertiary'))
                      .textAlign(TextAlign.Center)
                      .padding({ left: 12, right: 12 })
                  }
                  .justifyContent(FlexAlign.Center)
                }
                .width('100%')
                .height(170)
                .backgroundColor(this.plateDone ? $r('app.color.c_success_bg') : $r('app.color.c_surface_soft'))
                .borderRadius(12)
                .onClick(() => {
                  this.startRecognize();
                })
              }
              .width('100%')
              .padding(14)
              .backgroundColor($r('app.color.c_card_bg'))
              .borderRadius(14)

              // 今日任务
              Column({ space: 12 }) {
                Text('今日节约任务')
                  .fontSize(15)
                  .fontWeight(FontWeight.Bold)
                  .fontColor($r('app.color.c_text_primary'))
                  .width('100%')
                ForEach(DAILY_TASKS, (t: TaskDef) => {
                  Row({ space: 10 }) {
                    Text(t.emoji)
                      .fontSize(22)
                      .width(40)
                      .height(40)
                      .textAlign(TextAlign.Center)
                      .backgroundColor($r('app.color.c_surface_soft'))
                      .borderRadius(20)
                    Column({ space: 3 }) {
                      Text(t.title)
                        .fontSize(14)
                        .fontWeight(FontWeight.Medium)
                        .fontColor($r('app.color.c_text_primary'))
                      Text(t.desc)
                        .fontSize(11)
                        .fontColor($r('app.color.c_text_tertiary'))
                    }
                    .alignItems(HorizontalAlign.Start)
                    .layoutWeight(1)
                    if (Store.isTaskDone(t.id)) {
                      Text('已领取')
                        .fontSize(12)
                        .fontColor($r('app.color.c_text_tertiary'))
                        .backgroundColor($r('app.color.c_chip_bg'))
                        .padding({ left: 10, right: 10, top: 6, bottom: 6 })
                        .borderRadius(14)
                    } else {
                      Text(`+${t.points}`)
                        .fontSize(12)
                        .fontColor($r('app.color.c_success'))
                        .backgroundColor($r('app.color.c_success_bg'))
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
              .backgroundColor($r('app.color.c_card_bg'))
              .borderRadius(14)

              // 节约榜
              Column({ space: 10 }) {
                Row({ space: 8 }) {
                  Text('光盘节约榜')
                    .fontSize(15)
                    .fontWeight(FontWeight.Bold)
                    .fontColor($r('app.color.c_text_primary'))
                  DemoBadge()
                  Blank()
                  Text('本月 · 演示数据')
                    .fontSize(11)
                    .fontColor($r('app.color.c_text_tertiary'))
                }
                .width('100%')
                ForEach(RANK_LIST, (r: RankItem, idx: number) => {
                  Row({ space: 10 }) {
                    Text(this.rankLabel(idx))
                      .fontSize(idx < 3 ? 14 : 12)
                      .fontWeight(FontWeight.Bold)
                      .fontColor($r('app.color.c_rank_no'))
                      .textAlign(TextAlign.Center)
                      .width(24)
                      .height(24)
                      .borderRadius(12)
                      .backgroundColor(idx < 3 ? Color.Transparent : $r('app.color.c_chip_bg'))
                    Text(r.name)
                      .fontSize(13)
                      .fontColor(r.self === true ? $r('app.color.c_success') : $r('app.color.c_text_body'))
                      .fontWeight(r.self === true ? FontWeight.Bold : FontWeight.Normal)
                      .layoutWeight(1)
                    Text(`${r.days} 天`)
                      .fontSize(13)
                      .fontColor($r('app.color.c_text_secondary'))
                  }
                  .width('100%')
                  .padding({ top: 6, bottom: 6 })
                }, (r: RankItem, idx: number) => r.name + idx.toString())
              }
              .width('100%')
              .padding(14)
              .backgroundColor($r('app.color.c_card_bg'))
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
        .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
        .backgroundColor($r('app.color.c_page_bg'))
      }
      .width('100%')
      .height('100%')

      // AI 识别中遮罩
      if (this.recognizing) {
        Column({ space: 14 }) {
          Text('🔍')
            .fontSize(42)
          Text('识别中…（演示）')
            .fontSize(16)
            .fontColor(Color.White)
          Text('演示流程：不会真实分析或上传任何图像')
            .fontSize(12)
            .fontColor($r('app.color.c_on_brand_sub'))
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .backgroundColor($r('app.color.c_mask'))
      }

      // 打卡成功弹层
      if (this.showSuccess) {
        Column({ space: 16 }) {
          Column({ space: 8 }) {
            Text('🎉')
              .fontSize(48)
            Text('光盘成功！（演示）')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.c_text_primary'))
            Text('珍惜粮食，感谢你的坚持')
              .fontSize(13)
              .fontColor($r('app.color.c_text_secondary'))
            Text('+20 积分（演示数据）')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.c_success'))
              .margin({ top: 4 })
          }
          Button('开心收下')
            .fontSize(15)
            .fontColor(Color.White)
            .backgroundColor('#177A4C')
            .width(200)
            .height(44)
            .borderRadius(22)
            .onClick(() => {
              this.showSuccess = false;
            })
        }
        .width('82%')
        .padding({ top: 30, bottom: 26, left: 20, right: 20 })
        .backgroundColor($r('app.color.c_card_bg'))
        .borderRadius(18)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.c_page_bg'))
  }
}
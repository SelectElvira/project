# RFM-сегментация клиентов интернет-магазина

Этот проект представляет собой RFM-анализ клиентов интернет-магазина, выполненный с использованием SQL. 
Цель проекта - сегментировать клиентов на основе их покупательского поведения для разработки персонализированных маркетинговых стратегий.

## Данные

Данные для анализа взяты из датасета c Kaggle [Online Retail II UCI](https://www.kaggle.com/datasets/mashlyn/online-retail-ii-uci). 
Этот набор данных содержит информацию обо всех транзакциях, произошедших в период с 12.01.2009 по 12.09.2011 в компании из Великобритании, 
занимающейся только онлайн-торговлей. Компания в основном продает уникальные подарки на все случаи жизни. Многие клиенты компании являются оптовиками.

## Подготовка данных

Перед проведением RFM анализа была сделана подготовка данных, а именно:
1. Поиск значений NULL и приведение типов данных к верным значениям 
2. Описательная статистика (AVG, MIN, MAX, STDDEV для Price и Quantity)
3. Исследование группы клиентов с утерянным Customer ID (Выручка, количество транзакций, продажи по месяцам, по дням недели, по часам, средний чек, средняя цена)
4. Поиск и удаление дубликатов
5. Подготовка таблицы к RFM анализу: удаление пустых, нулевых значений, отмененных транзакций.

## RFM анализ

В данном проекте для расчета RFM-метрик использовались следующие метрики:

1. _LastPurchaseDate_ - Расчет давности последней покупки для каждого клиента;
2. _Frequency_ - Расчет частоты покупок для каждого клиента;
3. _Monetary Value_ - Расчет общей суммы покупок для каждого клиента.

Метод сегментации:
В результате проб деления на различное количество квантилей (4, 3, 5, 7) оптимальным оказалось деление на 4, иначе получаются очень разнородные группы. 
После расчета RFM-метрик, клиенты были сегментированы на группы: 'Новые клиенты', 'Золотые клиенты', 'Регулярные клиенты', 'Риск' и 'Потерянные (Churn)'.
А также расчитаны метрики для каждого сегмента: группировка по странам, по уникальному количеству клиентов, общая сумма покупок, средняя сумма покупок, общее количество заказов, а также 
процент клиентов в данном сегменте и стране от общего числа клиентов в этом сегменте. 

**Описание сегментов:** 

**Новые клиенты** (R_Score = 4): Это клиенты, которые совершили свои покупки совсем недавно. 
Для них можно предложить приветственные бонусы, программы лояльности и персонализированные рекомендации, чтобы стимулировать повторные покупки.

**Золотые клиенты** (R_Score = 3 AND F_Score >= 3 AND M_Score >= 3): Это самые важные и лучшие клиенты. Они покупают часто, недавно и тратят много. 
Можно предлагать: эксклюзивные скидки, ранний доступ к новым продуктам, персонализированное обслуживание и программы лояльности премиум-класса.

**Регулярные клиенты** (R_Score = 3 AND (F_Score < 3 OR M_Score < 3) OR R_Score = 2 AND F_Score >= 2 AND M_Score >= 2): 
Это клиенты, которые покупают достаточно регулярно и приносят стабильный доход, но не так часто или много, как "золотые" клиенты. 
С ними стоит работать, предлагая им персонализированные рекомендации, акции на товары, которые могут их заинтересовать, и программы лояльности, чтобы подтолкнуть их к более частым покупкам.

**Риск** (R_Score = 2 AND (F_Score < 2 OR M_Score < 2)): Эти клиенты покупали не так давно, не часто и/или тратили мало. Есть риск, что они уйдут к конкурентам. 
Важно понять причину их снижения активности. Можно предложить им специальные скидки, провести опросы для выяснения их потребностей и далее скорректировать маркетинговую программу.

**Потерянные** (Churn) (R_Score = 1): Это клиенты, которые давно ничего не покупали. Вероятность их возвращения низкая. 
Можно попробовать реактивировать их с помощью специальных предложений или акций. Необходимо проанализировать причины их ухода и предотвратить отток других клиентов.



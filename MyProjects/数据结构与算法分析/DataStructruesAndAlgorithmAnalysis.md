# Data Structrues and Algorithm Analysis

## Content

<!-- vim-markdown-toc GFM -->

* [References](#references)
* [排序算法](#排序算法)
    * [Insertion Sort](#insertion-sort)
    * [Selection Sort](#selection-sort)
    * [Bubble Sort](#bubble-sort)
    * [Merge Sort（归并排序）](#merge-sort归并排序)
    * [Quick Sort（快速排序）](#quick-sort快速排序)
    * [Shell Sort（希尔排序）](#shell-sort希尔排序)
    * [Heap Sort（堆排序）](#heap-sort堆排序)
    * [External Sort（外部排序）](#external-sort外部排序)
        * [用胜者树合并的外部排序](#用胜者树合并的外部排序)
        * [用败者树合并的外部排序](#用败者树合并的外部排序)
    * [Counting Sort（计数排序）](#counting-sort计数排序)
    * [Bucket Sort（桶排序）](#bucket-sort桶排序)
    * [Radix Sort（基数排序）](#radix-sort基数排序)
* [List](#list)
    * [Linked List](#linked-list)
        * [Single Linked List](#single-linked-list)
        * [Double Linked List](#double-linked-list)
        * [Circular Linked List](#circular-linked-list)
* [Tree](#tree)
    * [Basic Tree](#basic-tree)
    * [BinSearchTree（二叉查找树）](#binsearchtree二叉查找树)
    * [AVL Tree（自平衡二叉查找树）](#avl-tree自平衡二叉查找树)
    * [Splay Tree（伸展树）](#splay-tree伸展树)
    * [BTree（多路搜索树）](#btree多路搜索树)
    * [Huffman Tree（哈夫曼树）](#huffman-tree哈夫曼树)
* [Heap](#heap)
    * [Binary Heap（二叉堆）](#binary-heap二叉堆)
    * [Leftist Heap（左式堆）](#leftist-heap左式堆)
    * [Skew Heap（斜堆）](#skew-heap斜堆)
    * [Binomial Queue（二项队列）](#binomial-queue二项队列)
* [Hash Table](#hash-table)
    * [SeparateChaining](#separatechaining)
    * [OpenAddressing](#openaddressing)
* [Stack, Queue](#stack-queue)
    * [Stack](#stack)
        * [用数组实现](#用数组实现)
        * [用链表实现](#用链表实现)
    * [Queue](#queue)
        * [用数组实现](#用数组实现-1)
        * [用链表实现](#用链表实现-1)

<!-- vim-markdown-toc -->

## References

-   《数据结构与算法分析》

## 排序算法

### Insertion Sort

```c
#include <stdio.h>
#include <time.h>
#include <stdlib.h>

#define ARRAY_SIZE (10000 * 10)

void insertionSort(int* array, int n);

static int checkArrayOrder(const int* array, int n);

void insertionSort(int* array, int n) {
    int temp;
    for (int i = 1; i < n; i++) {
        // j 表示将要插入的位置
        int j = i;
        // 防止覆盖，取出将要插入的数
        temp = array[j];
        // 移动。遇到 <= temp 的数停止，或到 j == 0
        while (j > 0 && array[j - 1] > temp) {
            array[j] = array[j - 1];
            j--;
        }
        array[j] = temp;
    }
}

static int checkArrayOrder(const int* array, int n) {
    for (int i = 1; i < n; i++) {
        if (array[i - 1] > array[i]) {
            return -1;
        }
    }

    return 0;
}

void printArray(const int* array, int n) {
    for (int i = 0; i < n; i++) {
        printf("%d\t", array[i]);
    }
    printf("\n");
}

void genRandomNums(int* outArray, int n, int lower, int upper) {
    srand(time(0));
    int tmpUpper = upper - lower + 1;
    for (int i = 0; i < n; i++) {
        outArray[i] = rand() % tmpUpper + lower;
    }
}

clock_t getTime() {
    clock_t t = clock();
    if (t == (clock_t)-1) {
        fprintf(stderr, "clock() failed\n");
        exit(EXIT_FAILURE);
    }
    return t;
}

int main() {
    int array[ARRAY_SIZE];
    genRandomNums(array, ARRAY_SIZE, 1, ARRAY_SIZE);

    clock_t start, end, duration;
    start = getTime();
    insertionSort(array, ARRAY_SIZE);
    end = getTime();
    // 取上限
    duration = ((end - start) - 1) / CLOCKS_PER_SEC + 1;
    printArray(array, ARRAY_SIZE);
    printf("duration = %lfs\n", (double) duration);

    int checkRet = checkArrayOrder(array, ARRAY_SIZE);
    if (checkRet < 0) {
        fprintf(stderr, "checkRet = %d\n", checkRet);
        exit(EXIT_FAILURE);
    }

    return 0;
}
```

### Selection Sort

```c
#include <stdio.h>
#include <time.h>
#include <stdlib.h>

#define ARRAY_SIZE (10000 * 10)

void selectionSort(int* array, int n);

static inline void swap(int* a, int* b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

static int checkArrayOrder(const int* array, int n);

void selectionSort(int* array, int n) {
    int minIndex;
    for (int i = 0; i < n; i++) {
        minIndex = i;
        for (int j = i + 1; j < n; j++) {
            if (array[j] < array[minIndex]) {
                minIndex = j;
            }
        }

        // swap min to sorted list
        swap(&array[i], &array[minIndex]);
    }
}

static int checkArrayOrder(const int* array, int n) {
    for (int i = 1; i < n; i++) {
        if (array[i - 1] > array[i]) {
            return -1;
        }
    }

    return 0;
}

void printArray(const int* array, int n) {
    for (int i = 0; i < n; i++) {
        printf("%d\t", array[i]);
    }
    printf("\n");
}

void genRandomNums(int* outArray, int n, int lower, int upper) {
    srand(time(0));
    int tmpUpper = upper - lower + 1;
    for (int i = 0; i < n; i++) {
        outArray[i] = rand() % tmpUpper + lower;
    }
}

clock_t getTime() {
    clock_t t = clock();
    if (t == (clock_t)-1) {
        fprintf(stderr, "clock() failed\n");
        exit(EXIT_FAILURE);
    }
    return t;
}

int main() {
    int array[ARRAY_SIZE];
    genRandomNums(array, ARRAY_SIZE, 1, ARRAY_SIZE);

    clock_t start, end, duration;
    start = getTime();
    selectionSort(array, ARRAY_SIZE);
    end = getTime();
    // 取上限
    duration = ((end - start) - 1) / CLOCKS_PER_SEC + 1;
    printArray(array, ARRAY_SIZE);
    printf("duration = %lfs\n", (double) duration);

    int checkRet = checkArrayOrder(array, ARRAY_SIZE);
    if (checkRet < 0) {
        fprintf(stderr, "checkRet = %d\n", checkRet);
        exit(EXIT_FAILURE);
    }

    return 0;
}
```

### Bubble Sort

```c
#include <stdio.h>
#include <time.h>
#include <stdlib.h>

#define ARRAY_SIZE (10000 * 10)

void bubbleSort(int* array, int n);

static inline void swap(int* a, int* b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

static int checkArrayOrder(const int* array, int n);

void bubbleSort(int* array, int n) {
    // 从后向前冒泡
    for (int i = 0; i < n; i++) {
        for (int j = n - 1; j > i; j--) {
            if (array[j] < array[j - 1]) {
                swap(&array[j], &array[j - 1]);
            }
        }
    }
}

static int checkArrayOrder(const int* array, int n) {
    for (int i = 1; i < n; i++) {
        if (array[i - 1] > array[i]) {
            return -1;
        }
    }

    return 0;
}

void printArray(const int* array, int n) {
    for (int i = 0; i < n; i++) {
        printf("%d\t", array[i]);
    }
    printf("\n");
}

void genRandomNums(int* outArray, int n, int lower, int upper) {
    srand(time(0));
    int tmpUpper = upper - lower + 1;
    for (int i = 0; i < n; i++) {
        outArray[i] = rand() % tmpUpper + lower;
    }
}

clock_t getTime() {
    clock_t t = clock();
    if (t == (clock_t)-1) {
        fprintf(stderr, "clock() failed\n");
        exit(EXIT_FAILURE);
    }
    return t;
}

int main() {
    int array[ARRAY_SIZE];
    genRandomNums(array, ARRAY_SIZE, 1, ARRAY_SIZE);

    clock_t start, end, duration;
    start = getTime();
    bubbleSort(array, ARRAY_SIZE);
    end = getTime();
    // 取上限
    duration = ((end - start) - 1) / CLOCKS_PER_SEC + 1;
    printArray(array, ARRAY_SIZE);
    printf("duration = %lfs\n", (double) duration);

    int checkRet = checkArrayOrder(array, ARRAY_SIZE);
    if (checkRet < 0) {
        fprintf(stderr, "checkRet = %d\n", checkRet);
        exit(EXIT_FAILURE);
    }

    return 0;
}
```

### Merge Sort（归并排序）

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define ARRAY_SIZE (10000 * 10)

void mergeSort(int* array, int n);

static void mSort(int* array, int* tmpArray, int left, int right);
static void merge(int* array, int* tmpArray, int leftPos, int rightPos, int rightEnd);

static int checkArrayOrder(const int* array, int n);

void mergeSort(int* array, int n) {
    int* tmpArray = malloc(n * sizeof(int));
    if (!tmpArray) {
        fprintf(stderr, "No space for tmpArray!\n");
        exit(EXIT_FAILURE);
    }

    mSort(array, tmpArray, 0, n - 1);

    free(tmpArray);
}

// 将已排序的数列 [leftPos, rightPos), [rightPos, rightEnd] 合并
static void merge(int* array, int* tmpArray, int leftPos, int rightPos, int rightEnd) {
    // ### 比较两个数列，每个数列拿出最小的数比较，最小者就两个数列中最小的数
    // #### 保存信息, 因为之后修改参数
    int elementNum = rightEnd - leftPos + 1;
    int leftEnd = rightPos - 1;
    int tmpPos = leftPos;
    while (leftPos <= leftEnd && rightPos <= rightEnd) {
        if (array[leftPos] < array[rightPos]) {
            tmpArray[tmpPos++] = array[leftPos++];
        } else {
            tmpArray[tmpPos++] = array[rightPos++];
        }
    }

    // ### 将剩余的数放入 tmpArray 中
    while (leftPos <= leftEnd) {
        tmpArray[tmpPos++] = array[leftPos++];
    }

    while (rightPos <= rightEnd) {
        tmpArray[tmpPos++] = array[rightPos++];
    }

    // ### 排序结果放入 array 的 [leftPos, rightEnd] 中
    for (int i = 0; i < elementNum; i++) {
        array[rightEnd] = tmpArray[rightEnd];
        rightEnd--;
    }
}

static void mSort(int* array, int* tmpArray, int left, int right) {
    // ### base case
    // 少于一个数
    if (right - left + 1 <= 1) {
        return;
    }

    int center = (left + right) / 2;
    mSort(array, tmpArray, left, center);
    mSort(array, tmpArray, center + 1, right);
    merge(array, tmpArray, left, center + 1, right);
}

static int checkArrayOrder(const int* array, int n) {
    for (int i = 1; i < n; i++) {
        if (array[i - 1] > array[i]) {
            return -1;
        }
    }

    return 0;
}

void printArray(const int* array, int n) {
    for (int i = 0; i < n; i++) {
        printf("%d\t", array[i]);
    }
    printf("\n");
}

void genRandomNums(int* outArray, int n, int lower, int upper) {
    srand(time(0));
    int tmpUpper = upper - lower + 1;
    for (int i = 0; i < n; i++) {
        outArray[i] = rand() % tmpUpper + lower;
    }
}

clock_t getTime() {
    clock_t t = clock();
    if (t == (clock_t)-1) {
        fprintf(stderr, "clock() failed\n");
        exit(EXIT_FAILURE);
    }
    return t;
}

int main() {
    int array[ARRAY_SIZE];
    genRandomNums(array, ARRAY_SIZE, 1, ARRAY_SIZE);

    clock_t start, end, duration;
    start = getTime();
    mergeSort(array, ARRAY_SIZE);
    end = getTime();
    // 取上限
    duration = ((end - start) - 1) / CLOCKS_PER_SEC + 1;
    printArray(array, ARRAY_SIZE);
    printf("duration = %lfs\n", (double) duration);

    int checkRet = checkArrayOrder(array, ARRAY_SIZE);
    if (checkRet < 0) {
        fprintf(stderr, "checkRet = %d\n", checkRet);
        exit(EXIT_FAILURE);
    }

    return 0;
}
```

### Quick Sort（快速排序）

```c
#include <stdio.h>
#include <time.h>
#include <stdlib.h>

#define ARRAY_SIZE (10000 * 10)

void quickSort(int* array, int n);

static inline void swap(int* a, int* b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

static void qSort(int* array, int left, int right);
static int median3(int* array, int left, int right);
static void insertionSort(int* array, int n);

static int checkArrayOrder(const int* array, int n);

void quickSort(int* array, int n) {
    qSort(array, 0, n - 1);
}

void qSort(int* array, int left, int right) {
    int elementNum = right - left + 1;
    if (elementNum <= 3) {
        // 插入排序
        insertionSort(array + left, elementNum);
        return;
    }

    int pivot = median3(array, left, right);

    int i = left, j = right - 1;
    while (1) {
        // 找到 array[i] >= pivot
        // 这种方式下，如果所有数是 pivot（极小概率的情况）, 要检查 i 是否越界，所以不采用。
        // while (array[++i] <= pivot) { }
        while (array[++i] < pivot) { }
        // 找到 array[j] <= pivot
        while (array[--j] > pivot) { }
        // `i == j` 的情况是 `array[i] == pivot`。将 elementValue == pivot 的数放在左右都没有影响排序结果。
        if (i < j) {
            swap(&array[i], &array[j]);
        } else {
            break;
        }
    }

    // i 之后的数是小于 pivot 的，j 之后的数是大于 pivot 的。i 可能等于 j。

    // restore pivot
    swap(&array[i], &array[right - 1]);

    qSort(array, left, i - 1);
    qSort(array, i + 1, right);
}

int median3(int* array, int left, int right) {
    int center = (right + left) / 2;

    // 冒泡排序
    if (array[right] < array[center]) {
        swap(&array[right], &array[center]);
    }

    if (array[center] < array[left]) {
        swap(&array[center], &array[left]);
    }

    if (array[right] < array[center]) {
        swap(&array[right], &array[center]);
    }

    // hide pivot
    swap(&array[center], &array[right - 1]);
    return array[right - 1];
}

static void insertionSort(int* array, int n) {
    int temp;
    for (int i = 1; i < n; i++) {
        // j 表示将要插入的位置
        int j = i;
        // 防止覆盖，取出将要插入的数
        temp = array[j];
        // 移动。遇到 <= temp 的数停止，或到 j == 0
        while (j > 0 && array[j - 1] > temp) {
            array[j] = array[j - 1];
            j--;
        }
        array[j] = temp;
    }
}

static int checkArrayOrder(const int* array, int n) {
    for (int i = 1; i < n; i++) {
        if (array[i - 1] > array[i]) {
            return -1;
        }
    }

    return 0;
}

void printArray(const int* array, int n) {
    for (int i = 0; i < n; i++) {
        printf("%d\t", array[i]);
    }
    printf("\n");
}

void genRandomNums(int* outArray, int n, int lower, int upper) {
    srand(time(0));
    int tmpUpper = upper - lower + 1;
    for (int i = 0; i < n; i++) {
        outArray[i] = rand() % tmpUpper + lower;
    }
}

clock_t getTime() {
    clock_t t = clock();
    if (t == (clock_t)-1) {
        fprintf(stderr, "clock() failed\n");
        exit(EXIT_FAILURE);
    }
    return t;
}

int main() {
    int array[ARRAY_SIZE];
    genRandomNums(array, ARRAY_SIZE, 1, ARRAY_SIZE);

    clock_t start, end, duration;
    start = getTime();
    quickSort(array, ARRAY_SIZE);
    end = getTime();
    // 取上限
    duration = ((end - start) - 1) / CLOCKS_PER_SEC + 1;
    printArray(array, ARRAY_SIZE);
    printf("duration = %lfs\n", (double) duration);

    int checkRet = checkArrayOrder(array, ARRAY_SIZE);
    if (checkRet < 0) {
        fprintf(stderr, "checkRet = %d\n", checkRet);
        exit(EXIT_FAILURE);
    }

    return 0;
}
```

### Shell Sort（希尔排序）

```c
#include <stdio.h>
#include <time.h>
#include <stdlib.h>

#define ARRAY_SIZE (10000 * 10)

void shellSort(int* array, int n);

static int checkArrayOrder(const int* array, int n);

void shellSort(int* array, int n) {
    for (int increment = n / 2; increment > 0; increment /= 2) {
        // ### 采用插入排序
        // 所有增量序列一起排序, 而不是先排序一个增量序列一再排序另一个。
        for (int i = increment; i < n; i++) {
            int temp = array[i];
            int j = i;

            // 移位，直至遇到合适的位置，或数列的首位
            while (j - increment >= 0 && array[j - increment] > temp) {
                array[j] = array[j - increment];
                j -= increment;
            }

            // 插入
            array[j] = temp;
        }
    }
}

static int checkArrayOrder(const int* array, int n) {
    for (int i = 1; i < n; i++) {
        if (array[i - 1] > array[i]) {
            return -1;
        }
    }

    return 0;
}

void printArray(int* array, int n) {
    for (int i = 0; i < n; i++) {
        printf("%d\t", array[i]);
    }
    printf("\n");
}

void genRandomNums(int* outArray, int n, int lower, int upper) {
    srand(time(0));
    int tmpUpper = upper - lower + 1;
    for (int i = 0; i < n; i++) {
        outArray[i] = rand() % tmpUpper + lower;
    }
}

clock_t getTime() {
    clock_t t = clock();
    if (t == (clock_t)-1) {
        fprintf(stderr, "clock() failed\n");
        exit(EXIT_FAILURE);
    }
    return t;
}

int main() {
    int array[ARRAY_SIZE];
    genRandomNums(array, ARRAY_SIZE, 1, ARRAY_SIZE);

    clock_t start, end, duration;
    start = getTime();
    shellSort(array, ARRAY_SIZE);
    end = getTime();
    // 取上限
    duration = ((end - start) - 1) / CLOCKS_PER_SEC + 1;
    printArray(array, ARRAY_SIZE);
    printf("duration = %lfs\n", (double) duration);

    int checkRet = checkArrayOrder(array, ARRAY_SIZE);
    if (checkRet < 0) {
        fprintf(stderr, "checkRet = %d\n", checkRet);
        exit(EXIT_FAILURE);
    }

    return 0;
}
```

### Heap Sort（堆排序）

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define ARRAY_SIZE (10000 * 10)

void heapSort(int* array, int n);

static inline void swap(int* a, int* b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

static void adjustDown(int nonLeafNodeNum, int* heap, int heapSize);

static int checkMaxHeap(const int* array, int n);
static int checkArrayOrder(const int* array, int n);

// 从小到大排序
void heapSort(int* array, int n) {
    // ### 构造最大堆
    int* heap = malloc(sizeof(int) * (n + 1));
    if (!heap) {
        fprintf(stderr, "No space for heap!\n");
        exit(EXIT_FAILURE);
    }
    int heapSize = n;

    for (int i = 0; i < n; i++) {
        heap[i + 1] = array[i];
    }

    int nonLeafCount = n / 2;
    for (int j = nonLeafCount; j > 0; j--) {
        adjustDown(j, heap, heapSize);
    }

    // ### 排序
    for (int m = 0; m < n; m++) {
        swap(&heap[1], &heap[heapSize]);
        heapSize--;
        adjustDown(1, heap, heapSize);

        // ### debug
        /* int checkRet = checkMaxHeap(heap, heapSize); */
        /* if (checkRet < 0) { */
        /*     fprintf(stderr, "checkRet = %d\n", checkRet); */
        /*     exit(EXIT_FAILURE); */
        /* } */
    }

    // ### 将结果放入 array
    for (int k = 0; k < n; k++) {
        array[k] = heap[k + 1];
    }

    // ### 回收内存
    free(heap);
}

void adjustDown(int nonLeafNodeNum, int* heap, int heapSize) {
    int leftChildNum;
    int rightChildNum;
    int maxNodeNum;
    int theNodeNum = nonLeafNodeNum;
    int nonLeafCount = heapSize / 2;
    while (theNodeNum <= nonLeafCount) {
        leftChildNum = theNodeNum * 2;
        rightChildNum = leftChildNum + 1;

        maxNodeNum = theNodeNum;
        if (heap[leftChildNum] > heap[maxNodeNum]) {
            maxNodeNum = leftChildNum;
        }
        if (rightChildNum <= heapSize && heap[rightChildNum] > heap[maxNodeNum]) {
            maxNodeNum = rightChildNum;
        }

        if (maxNodeNum != theNodeNum) {
            swap(&heap[maxNodeNum], &heap[theNodeNum]);
            theNodeNum = maxNodeNum;
        } else {
            break;
        }
    }
}

static int checkMaxHeap(const int* array, int n) {
    int curPos = 1;
    int leftChildPos = 2 * curPos;
    int rightChildPos;
    while (leftChildPos < n) {
        if (array[leftChildPos] > array[curPos]) {
            return -1;
        }

        rightChildPos = leftChildPos + 1;
        if (rightChildPos < n) {
            if (array[rightChildPos] > array[curPos]) {
                return -2;
            }
        }

        curPos++;
        leftChildPos = 2 * curPos;
        rightChildPos = leftChildPos + 1;
    }

    return 0;
}

static int checkArrayOrder(const int* array, int n) {
    for (int i = 1; i < n; i++) {
        if (array[i - 1] > array[i]) {
            return -1;
        }
    }

    return 0;
}

void printArray(const int* array, int n) {
    for (int i = 0; i < n; i++) {
        printf("%d\t", array[i]);
    }
    printf("\n");
}

void genRandomNums(int* outArray, int n, int lower, int upper) {
    srand(time(0));
    int tmpUpper = upper - lower + 1;
    for (int i = 0; i < n; i++) {
        outArray[i] = rand() % tmpUpper + lower;
    }
}

clock_t getTime() {
    clock_t t = clock();
    if (t == (clock_t)-1) {
        fprintf(stderr, "clock() failed\n");
        exit(EXIT_FAILURE);
    }
    return t;
}

int main() {
    int array[ARRAY_SIZE];
    genRandomNums(array, ARRAY_SIZE, 1, ARRAY_SIZE);

    clock_t start, end, duration;
    start = getTime();
    heapSort(array, ARRAY_SIZE);
    end = getTime();
    // 取上限
    duration = ((end - start) - 1) / CLOCKS_PER_SEC + 1;
    printArray(array, ARRAY_SIZE);
    printf("duration = %lfs\n", (double) duration);

    int checkRet = checkArrayOrder(array, ARRAY_SIZE);
    if (checkRet < 0) {
        fprintf(stderr, "checkRet = %d\n", checkRet);
        exit(EXIT_FAILURE);
    }

    return 0;
}
```

### External Sort（外部排序）

[ref](https://www.cnblogs.com/qianye/archive/2012/11/25/2787923.html)

#### 用胜者树合并的外部排序

胜者树

> 规律：树或子树的根节点是整棵树的最小的数。
>
> 左子树与右子树的胜者（小者胜）比较，胜者放入父结点。

```c
/***
### 该程序可以改进的地方

1. 可用 [0, K) 个叶子。

2. 将 leaves 与 nonleaves 放在一起。

    struct SuccessTreeStruct {
        ElementType nonLeaves[K];
        ElementType leaves[K];
    };

***/

#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <stdbool.h>
#include <string.h>
#include <time.h>

// K 路合并
#define K 5
#define MAX INT_MAX
// 取上限
#define ARRAY_SIZE (((10000 * 10) - 1) / K + 1)

// [1, K] 个叶子结点
int leaves[K + 1];
// [1, K - 1] 个非叶子结点
int successTree[K];

struct List {
    int count;
    int* data;
};

void successTreeSort(struct List* mergedList, struct List* listArray);

// ### 胜者树的相关函数
static void adjustToRoot(int leaveIndex);
static void adjustNode(int nodeNum);
static void initSuccessTree(struct List* listArray);

// ### list 相关的函数
static inline void listPush(const int* element, struct List* listPtr);
static inline int listPop(struct List* listPtr);
static inline bool listIsEmpty(const struct List* listPtr);

static int checkSuccessTree();
static int checkArrayOrder(const int* array, int n);
static void insertionSort(int* array, int n);
static void printArray(const int* array, int n);

// listArray 放置已排序的多条数组，mergedList 是合并后的数组。
void successTreeSort(struct List* mergedList, struct List* listArray) {
    // ### initSuccessTree
    initSuccessTree(listArray);

    int rootIndex;
    int runNum = K;
    while (runNum > 0) {
        rootIndex = successTree[1];
        listPush(&leaves[rootIndex], mergedList);
        if (!listIsEmpty(&listArray[rootIndex])) {
            leaves[rootIndex] = listPop(&listArray[rootIndex]);
        } else {
            leaves[rootIndex] = MAX;
            runNum--;
        }
        adjustToRoot(rootIndex);

        // ### debug
        /* int checkRet = checkSuccessTree(); */
        /* if (checkRet < 0) { */
        /*     fprintf(stderr, "checkSuccessTree checkRet = %d\n", checkRet); */
        /*     exit(EXIT_FAILURE); */
        /* } */
    }
}

static void adjustToRoot(int leaveIndex) {
    int parent = (leaveIndex + (K - 1));

    while (parent /= 2) {
        adjustNode(parent);
    }
}

// i 为非叶子结点的序号
static void adjustNode(int nodeNum) {
    // ### 获取左右结点的对应的叶子结点的索引
    // #### 获取左结点的叶子索引值
    int leftChildNum = 2 * nodeNum;
    int leftChildIndex;
    if (leftChildNum < K) {     // 结点是非叶子结点
        leftChildIndex = successTree[leftChildNum];
    } else {    // 结点是叶子结点
        leftChildIndex = leftChildNum - (K - 1);
    }

    // #### 获取右结点的叶子索引值
    int rightChildNum = leftChildNum + 1;
    int rightChildIndex;
    if (rightChildNum < K) {
        rightChildIndex = successTree[rightChildNum];
    } else {
        rightChildIndex = rightChildNum - (K - 1);
    }

    // ### 比较并调整结点（小者胜）
    successTree[nodeNum] = leaves[leftChildIndex] < leaves[rightChildIndex] ? leftChildIndex : rightChildIndex;
}

static void initSuccessTree(struct List* listArray) {
    for (int i = 1; i <= K; i++) {
        leaves[i] = listPop(&listArray[i]);
    }

    for (int j = K - 1; j > 0; j--) {
        adjustNode(j);
    }

}

static inline void listPush(const int* element, struct List* listPtr) {
    listPtr->data[listPtr->count++] = *element;
}

static inline int listPop(struct List* listPtr) {
    return listPtr->data[--listPtr->count];
}

static inline bool listIsEmpty(const struct List* listPtr) {
    return listPtr->count == 0 ? true : false;
}

static int checkSuccessTree() {
    int leftChildNum, rightChildNum;
    int leftChildIdx, rightChildIdx;

    for (int curNodeNum = 1; curNodeNum < K; curNodeNum++) {
        // ### 获取左节点的叶子结点的索引值
        leftChildNum = 2 * curNodeNum;
        if (leftChildNum < K) {
            leftChildIdx = successTree[leftChildNum];
        } else {
            leftChildIdx = leftChildNum - (K - 1);
        }

        // ### 获取右节点的叶子结点的索引值
        rightChildNum = leftChildNum + 1;
        if (rightChildNum < K) {
            rightChildIdx = successTree[rightChildNum];
        } else {
            rightChildIdx = rightChildNum - (K - 1);
        }

        // ### 检查父结点是否存放最小节点的叶子索引值
        if (leaves[leftChildIdx] < leaves[rightChildIdx]) {
            if (successTree[curNodeNum] != leftChildIdx) {
                return -1;
            }
        } else if (leaves[leftChildIdx] > leaves[rightChildIdx]) {
            if (successTree[curNodeNum] != rightChildIdx) {
                return -2;
            }
        } else {
            if (successTree[curNodeNum] != leftChildIdx && successTree[curNodeNum] != rightChildIdx) {
                return -3;
            }
        }
    }

    return 0;
}

static int checkArrayOrder(const int* array, int n) {
    for (int i = 1; i < n; i++) {
        if (array[i - 1] > array[i]) {
            return -1;
        }
    }

    return 0;
}

static void insertionSort(int* array, int n) {
    int temp;
    for (int i = 1; i < n; i++) {
        // j 表示将要插入的位置
        int j = i;
        // 防止覆盖，取出将要插入的数
        temp = array[j];
        // 移动。遇到 <= temp 的数停止，或到 j == 0
        while (j > 0 && array[j - 1] > temp) {
            array[j] = array[j - 1];
            j--;
        }
        array[j] = temp;
    }
}

static void printArray(const int* array, int n) {
    for (int i = 0; i < n; i++) {
        printf("%d\t", array[i]);
    }
    printf("\n");
}

static void genRandomNums(int* outArray, int n, int lower, int upper) {
    srand(time(0));
    int tmpUpper = upper - lower + 1;
    for (int i = 0; i < n; i++) {
        outArray[i] = rand() % tmpUpper + lower;
    }
}

static clock_t getTime() {
    clock_t t = clock();
    if (t == (clock_t)-1) {
        fprintf(stderr, "clock() failed\n");
        exit(EXIT_FAILURE);
    }
    return t;
}

static void testSuccessTreeSort() {
    // ### 初始化 listArray, mergedList
    // #### 为 listArray 分配内存
    // listArray[0] 不使用
    struct List* listArray = malloc(sizeof(struct List) * (K + 1));
    if (!listArray) {
        fprintf(stderr, "No space for listArray\n");
        exit(EXIT_FAILURE);
    }

    for (int i = 1; i < K + 1; i++) {
        listArray[i].data = malloc(sizeof(int) * ARRAY_SIZE);
        if (!listArray[i].data) {
            fprintf(stderr, "No space for listArray[i].data\n");
            exit(EXIT_FAILURE);
        }
        listArray[i].count = 0;
    }

    // #### 为 mergedList 分配内存
    struct List* mergedList = malloc(sizeof(struct List));
    if (!mergedList) {
        fprintf(stderr, "No space for mergedList\n");
        exit(EXIT_FAILURE);
    }
    mergedList->data = malloc(sizeof(int) * ARRAY_SIZE * K);
    if (!mergedList->data) {
        fprintf(stderr, "No space for mergedList->data\n");
        exit(EXIT_FAILURE);
    }
    mergedList->count = 0;

    // ### 将已排序的数列放入 listArray
    int array[K + 1][ARRAY_SIZE];

    for (int q = 1; q <= K; q++) {
        genRandomNums(array[q], ARRAY_SIZE, 1, ARRAY_SIZE);
    }

    for (int j = 1; j <= K; j++) {
        insertionSort(array[j], ARRAY_SIZE);
        for (int k = ARRAY_SIZE - 1; k >= 0; k--) {
            listPush(&array[j][k], &listArray[j]);
        }
        printArray(listArray[j].data, listArray[j].count);
    }

    clock_t start, end, duration;
    start = getTime();
    successTreeSort(mergedList, listArray);
    end = getTime();
    // 取上限
    duration = ((end - start) - 1) / CLOCKS_PER_SEC + 1;

    /* int checkRet = checkArrayOrder(mergedList->data, mergedList->count); */
    /* if (checkRet < 0) { */
    /*     fprintf(stderr, "checkArrayOrder checkRet = %d\n", checkRet); */
    /*     exit(EXIT_FAILURE); */
    /* } */

    printf("mergedList(%d): ", mergedList->count);
    printArray(mergedList->data, mergedList->count);
    printf("duration = %lfs\n", (double) duration);

    // ### 回收内存
    // #### 回收 listArray
    for (int p = 1; p < K + 1; p++) {
        free(listArray[p].data);
    }
    free(listArray);

    // #### 回收 mergedList
    free(mergedList);
}

int main() {
    testSuccessTreeSort();

    return 0;
}
```

#### 用败者树合并的外部排序

败者树

> 规律：树或子树的根节点是整棵树的第二小的数。
>
> 左子树与右子树的胜者（小者胜）比较，败者放入父节点。

```c
/***
### 该程序可以改进的地方

1. 可用 [0, K) 个叶子。

2. 将 leaves 与 nonleaves 放在一起。

    struct SuccessTreeStruct {
        ElementType nonLeaves[K];
        ElementType leaves[K];
    };

***/

#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <stdbool.h>
#include <string.h>
#include <time.h>

// K 路合并
#define K 5
#define MIN INT_MIN
#define MAX INT_MAX
// 取上限
#define ARRAY_SIZE (((10000 * 10) - 1) / K + 1)

// [1, K] 个叶子结点
int leaves[K + 1];
// [1, K - 1] 个非叶子结点
int loserTree[K];

struct List {
    int count;
    int* data;
};

void loserTreeSort(struct List* mergedList, struct List* listArray);

static void adjustToRoot(int leaveIndex);
static void initloserTree(struct List* listArray);

static inline void listPush(const int* element, struct List* listPtr);
static inline int listPop(struct List* listPtr);
static inline bool listIsEmpty(const struct List* listPtr);

static int checkLoserTree(int* winnerIdx, int rootNum);
static int checkArrayOrder(const int* array, int n);

static void insertionSort(int* array, int n);
static void printArray(const int* array, int n);

void loserTreeSort(struct List* mergedList, struct List* listArray) {
    // ### initSuccessTree
    initloserTree(listArray);

    int winnerIndex;
    int runNum = K;
    while (runNum > 0) {
        winnerIndex = loserTree[0];
        listPush(&leaves[winnerIndex], mergedList);
        if (!listIsEmpty(&listArray[winnerIndex])) {
            leaves[winnerIndex] = listPop(&listArray[winnerIndex]);
        } else {
            leaves[winnerIndex] = MAX;
            runNum--;
        }
        adjustToRoot(winnerIndex);

        // ### debug
        /* int winnerIdx; */
        /* int checkRet = checkLoserTree(&winnerIdx, 1); */
        /* if (checkRet < 0) { */
        /*     fprintf(stderr, "checkLoserTree checkRet = %d\n", checkRet); */
        /*     exit(EXIT_FAILURE); */
        /* } */
    }
}

static void adjustToRoot(int leaveIndex) {
    int parent = leaveIndex + (K - 1);
    int winnerLeaveIndex = leaveIndex;
    int loserLeaveIndex;

    while (parent /= 2) {
        if (leaves[winnerLeaveIndex] > leaves[loserTree[parent]]) {
            loserLeaveIndex = winnerLeaveIndex;
            winnerLeaveIndex = loserTree[parent];
            loserTree[parent] = loserLeaveIndex;
        }
    }
    loserTree[0] = winnerLeaveIndex;
}

static void initloserTree(struct List* listArray) {
    leaves[0] = MIN;
    for (int i = 1; i <= K; i++) {
        leaves[i] = listPop(&listArray[i]);
    }

    for (int j = 1; j < K - 1; j++) {
        loserTree[j] = 0;
    }

    for (int j = K; j > 0; j--) {
        adjustToRoot(j);
    }

}

static inline void listPush(const int* element, struct List* listPtr) {
    listPtr->data[listPtr->count++] = *element;
}

static inline int listPop(struct List* listPtr) {
    return listPtr->data[--listPtr->count];
}

static inline bool listIsEmpty(const struct List* listPtr) {
    return listPtr->count == 0 ? true : false;
}

static int checkLoserTree(int* winnerIdx, int rootNum) {
    if (rootNum >= K) {
        *winnerIdx = rootNum - (K - 1);
        return 0;
    }

    int leftChildNum = 2 * rootNum;
    int leftChildWinnerIdx;
    int checkRet = checkLoserTree(&leftChildWinnerIdx, leftChildNum);
    if (checkRet < 0) {
        return checkRet;
    }
    int rightChildNum = leftChildNum + 1;
    int rightChildWinnerIdx;
    checkRet = checkLoserTree(&rightChildWinnerIdx, rightChildNum);
    if (checkRet < 0) {
        return checkRet;
    }

    int winnerIndex, loserIndex;
    if (leaves[leftChildWinnerIdx] < leaves[rightChildWinnerIdx]) {
        winnerIndex = leftChildWinnerIdx;
        loserIndex = rightChildWinnerIdx;
    } else {
        winnerIndex = rightChildWinnerIdx;
        loserIndex = leftChildWinnerIdx;
    }

    if (leaves[loserIndex] != leaves[loserTree[rootNum]]) {
        return -1;
    }

    if (rootNum == 1) {
        if (leaves[loserTree[0]] != leaves[winnerIndex]) {
            return -2;
        }
    }

    // ### 返回
    *winnerIdx = winnerIndex;

    return 0;
}

static int checkArrayOrder(const int* array, int n) {
    for (int i = 1; i < n; i++) {
        if (array[i - 1] > array[i]) {
            return -1;
        }
    }

    return 0;
}

static void insertionSort(int* array, int n) {
    int temp;
    for (int i = 1; i < n; i++) {
        // j 表示将要插入的位置
        int j = i;
        // 防止覆盖，取出将要插入的数
        temp = array[j];
        // 移动。遇到 <= temp 的数停止，或到 j == 0
        while (j > 0 && array[j - 1] > temp) {
            array[j] = array[j - 1];
            j--;
        }
        array[j] = temp;
    }
}

static void printArray(const int* array, int n) {
    for (int i = 0; i < n; i++) {
        printf("%d\t", array[i]);
    }
    printf("\n");
}

void genRandomNums(int* outArray, int n, int lower, int upper) {
    srand(time(0));
    int tmpUpper = upper - lower + 1;
    for (int i = 0; i < n; i++) {
        outArray[i] = rand() % tmpUpper + lower;
    }
}

clock_t getTime() {
    clock_t t = clock();
    if (t == (clock_t)-1) {
        fprintf(stderr, "clock() failed\n");
        exit(EXIT_FAILURE);
    }
    return t;
}

void testLoserTreeSort() {
    // ### 初始化 listArray, mergedList
    // #### 为 listArray 分配内存
    // listArray[0] 不使用
    struct List* listArray = malloc(sizeof(struct List) * (K + 1));
    if (!listArray) {
        fprintf(stderr, "No space for listArray\n");
        exit(EXIT_FAILURE);
    }

    for (int i = 1; i < K + 1; i++) {
        listArray[i].data = malloc(sizeof(int) * ARRAY_SIZE);
        if (!listArray[i].data) {
            fprintf(stderr, "No space for listArray[i].data\n");
            exit(EXIT_FAILURE);
        }
        listArray[i].count = 0;
    }

    // #### 为 mergedList 分配内存
    struct List* mergedList = malloc(sizeof(struct List));
    if (!mergedList) {
        fprintf(stderr, "No space for mergedList\n");
        exit(EXIT_FAILURE);
    }
    mergedList->data = malloc(sizeof(int) * ARRAY_SIZE * K);
    if (!mergedList->data) {
        fprintf(stderr, "No space for mergedList->data\n");
        exit(EXIT_FAILURE);
    }
    mergedList->count = 0;

    // ### 将已排序的数列放入 listArray
    int array[K + 1][ARRAY_SIZE];

    for (int q = 1; q <= K; q++) {
        genRandomNums(array[q], ARRAY_SIZE, 1, ARRAY_SIZE);
    }

    for (int j = 1; j <= K; j++) {
        insertionSort(array[j], ARRAY_SIZE);
        for (int k = ARRAY_SIZE - 1; k >= 0; k--) {
            listPush(&array[j][k], &listArray[j]);
        }
        printArray(listArray[j].data, listArray[j].count);
    }

    clock_t start, end, duration;
    start = getTime();
    loserTreeSort(mergedList, listArray);
    end = getTime();
    // 取上限
    duration = ((end - start) - 1) / CLOCKS_PER_SEC + 1;

    printf("mergedList(%d): ", mergedList->count);
    printArray(mergedList->data, mergedList->count);
    printf("duration = %lfs\n", (double) duration);

    /* int checkRet = checkArrayOrder(mergedList->data, mergedList->count); */
    /* if (checkRet < 0) { */
    /*     fprintf(stderr, "checkArrayOrder checkRet = %d\n", checkRet); */
    /*     exit(EXIT_FAILURE); */
    /* } */

    // ### 回收内存
    // #### 回收 listArray
    for (int p = 1; p < K + 1; p++) {
        free(listArray[p].data);
    }
    free(listArray);

    // #### 回收 mergedList
    free(mergedList);
}

int main() {
    testLoserTreeSort();

    return 0;
}
```

### Counting Sort（计数排序）

[ref](https://www.cnblogs.com/xiaochuan94/p/11198610.html)

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

// 内存至少 ARRAY_SIZE * 4B
#define ARRAY_SIZE (10000 * 100)

void countingSort(int* array, int n);

static int checkArrayOrder(const int* array, int n);

static void printArray(const int* array, int n);
static void genRandomNums(int* outArray, int n, int lower, int upper);
static clock_t getTime();

// array: [0, ~)
void countingSort(int* array, int n) {
    // ### 分配内存
    int min, max;
    min = max = array[0];

    for (int i = 1; i < n; i++) {
        if (array[i] < min) {
            min = array[i];
        }

        if (array[i] > max) {
            max = array[i];
        }
    }

    int elementNum = max - min + 1;
    int* countingArray = malloc(sizeof(int) * elementNum);
    memset(countingArray, 0, elementNum * sizeof(int));

    // ### 计数
    for (int j = 0; j < n; j++) {
        countingArray[array[j] - min] += 1;
    }

    // ### 复制结果
    int m = 0;
    for (int k = 0; k < elementNum; k++) {
        while (countingArray[k] > 0) {
            array[m++] = min + k;
            countingArray[k]--;
        }
    }

    // ### 回收内存
    free(countingArray);
}

static int checkArrayOrder(const int* array, int n) {
    for (int i = 1; i < n; i++) {
        if (array[i - 1] > array[i]) {
            // debug
            /* printf("[%d, %d] %d: %d, %d",n, n, i, array[i - 1], array[i]); */
            return -1;
        }
    }

    return 0;
}

static void printArray(const int* array, int n) {
    for (int i = 0; i < n; i++) {
        printf("%d\t", array[i]);
    }
    printf("\n");
}

static void genRandomNums(int* outArray, int n, int lower, int upper) {
    srand(time(0));
    int tmpUpper = upper - lower + 1;
    for (int i = 0; i < n; i++) {
        outArray[i] = rand() % tmpUpper + lower;
    }
}

static clock_t getTime() {
    clock_t t = clock();
    if (t == (clock_t)-1) {
        fprintf(stderr, "clock() failed\n");
        exit(EXIT_FAILURE);
    }
    return t;
}

int main() {
    int array[ARRAY_SIZE];
    genRandomNums(array, ARRAY_SIZE, 100, ARRAY_SIZE + 999);
    /* printArray(array, ARRAY_SIZE); */

    clock_t start, end, duration;
    start = getTime();
    countingSort(array, ARRAY_SIZE);
    end = getTime();
    // 取上限
    duration = ((end - start) - 1) / CLOCKS_PER_SEC + 1;
    printArray(array, ARRAY_SIZE);
    printf("duration = %lfs\n", (double) duration);

    /* int checkRet = checkArrayOrder(array, ARRAY_SIZE); */
    /* if (checkRet < 0) { */
    /*     fprintf(stderr, "checkRet = %d\n", checkRet); */
    /*     exit(EXIT_FAILURE); */
    /* } */

    return 0;
}
```

### Bucket Sort（桶排序）

将一定范围的数放入桶内，然后将桶内的数排序，再将数从桶内拿出。

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <time.h>

#define ARRAY_SIZE (10000 * 10)
// 假设数列均匀分布，每个桶可能放置数字的个数
#define BUCKET_DEFAULT_INCREMENT 10

struct bucket {
    int count;
    int* data;
};

void bucketSort(int* array, int n);

static inline void bucketPush(const int* element, struct bucket* bucketPtr);
static inline const int* bucketPop(struct bucket* bucketPtr);
static inline bool bucketIsEmpty(const struct bucket* bucketPtr);
static inline void bucketInsertionSort(struct bucket* bucketPtr);

static void insertionSort(int* array, int n);

static int checkArrayOrder(const int* array, int n);

static void printArray(const int* array, int n);
static void genRandomNums(int* outArray, int n, int lower, int upper);
static clock_t getTime();

void bucketSort(int* array, int n) {
    // ### 分配内存
    int min, max;
    min = max = array[0];

    for (int i = 1; i < n; i++) {
        if (array[i] < min) {
            min = array[i];
        }

        if (array[i] > max) {
            max = array[i];
        }
    }

    int bucketCount = n / BUCKET_DEFAULT_INCREMENT;

    // 取上限
    int increment = ((max - min) - 1) / bucketCount + 1;

    // #### 每个桶的容量（单位是数字）
    int bucketSize = n;

    // #### 桶的数量
    struct bucket* bucketList = malloc(sizeof(struct bucket) * bucketCount);
    if (!bucketList) {
        fprintf(stderr, "No space for bucketList!\n");
        exit(EXIT_FAILURE);
    }
    for (int j = 0; j < bucketCount; j++) {
        // 为桶分配内存
        bucketList[j].data = malloc(sizeof(int) * bucketSize);
        if (!bucketList[j].data) {
            fprintf(stderr, "No space for bucketList.data!\n");
            exit(EXIT_FAILURE);
        }

        // 初始化桶
        bucketList[j].count = 0;
    }

    // ### 将数字放入桶内
    for (int m = 0; m < n; m++) {
        for (int p = 1; p <= bucketCount; p++) {
            // 有可能数等于 `min + p * increment`
            if (array[m] <= min + p * increment) {
                bucketPush(&array[m], &bucketList[p - 1]);
                break;
            }
        }
    }

    // ### 排序每个桶
    for (int p = 0; p < bucketCount; p++) {
        bucketInsertionSort(&bucketList[p]);
    }

    // ### 将结果放到数组
    int arrayIndex = 0;
    for (int q = 0; q < bucketCount; q++) {
        while (!bucketIsEmpty(&bucketList[q])) {
            array[arrayIndex++] = *bucketPop(&bucketList[q]);
        }
    }

    // ### 回收内存
    for (int k = 0; k < bucketCount; k++) {
        free(bucketList[k].data);
    }
    free(bucketList);
}

static inline void bucketPush(const int* element, struct bucket* bucketPtr) {
    bucketPtr->data[bucketPtr->count++] = *element;
}

static inline const int* bucketPop(struct bucket* bucketPtr) {
    return &bucketPtr->data[--bucketPtr->count];
}

static inline bool bucketIsEmpty(const struct bucket* bucketPtr) {
    return bucketPtr->count == 0 ? true : false;
}

static inline void bucketInsertionSort(struct bucket* bucketPtr) {
    insertionSort(bucketPtr->data, bucketPtr->count);
}

static void insertionSort(int* array, int n) {
    int temp;
    for (int i = 1; i < n; i++) {
        // j 表示将要插入的位置
        int j = i;
        // 防止覆盖，取出将要插入的数
        temp = array[j];
        // 移动。遇到 <= temp 的数停止，或到 j == 0
        while (j > 0 && array[j - 1] < temp) {
            array[j] = array[j - 1];
            j--;
        }
        array[j] = temp;
    }
}

static int checkArrayOrder(const int* array, int n) {
    for (int i = 1; i < n; i++) {
        if (array[i - 1] > array[i]) {
            // debug
            /* printf("[%d, %d] %d: %d, %d",n, n, i, array[i - 1], array[i]); */
            return -1;
        }
    }

    return 0;
}

static void printArray(const int* array, int n) {
    for (int i = 0; i < n; i++) {
        printf("%d\t", array[i]);
    }
    printf("\n");
}

static void genRandomNums(int* outArray, int n, int lower, int upper) {
    srand(time(0));
    int tmpUpper = upper - lower + 1;
    for (int i = 0; i < n; i++) {
        outArray[i] = rand() % tmpUpper + lower;
    }
}

static clock_t getTime() {
    clock_t t = clock();
    if (t == (clock_t)-1) {
        fprintf(stderr, "clock() failed\n");
        exit(EXIT_FAILURE);
    }
    return t;
}

int main() {
    int array[ARRAY_SIZE];
    genRandomNums(array, ARRAY_SIZE, 1, ARRAY_SIZE);

    clock_t start, end, duration;
    start = getTime();
    bucketSort(array, ARRAY_SIZE);
    end = getTime();
    // 取上限
    duration = ((end - start) - 1) / CLOCKS_PER_SEC + 1;
    printArray(array, ARRAY_SIZE);
    printf("duration = %lfs\n", (double) duration);

    /* int checkRet = checkArrayOrder(array, ARRAY_SIZE); */
    /* if (checkRet < 0) { */
    /*     fprintf(stderr, "checkRet = %d\n", checkRet); */
    /*     exit(EXIT_FAILURE); */
    /* } */

    return 0;
}
```

### Radix Sort（基数排序）

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define ARRAY_SIZE (10000 * 10)

// 只能是 10
#define BUCKET_COUNT 10

void radixSort(int* array, int n);

static void radixSortWithExp(int* array, int n, int exp);
static int getMaxExp(const int* array, int n);
static inline int getBucketIndex(const int* element, int exp);

static int checkArrayOrder(const int* array, int n);

static void printArray(const int* array, int n);
static void genRandomNums(int* outArray, int n, int lower, int upper);
static clock_t getTime();

// 从小到大排序
void radixSort(int* array, int n) {
    int maxExp = getMaxExp(array, n);
    for (int exp = 1; exp <= maxExp; exp *= 10) {
        radixSortWithExp(array, n, exp);
    }
}

static void radixSortWithExp(int* array, int n, int exp) {
    int* bucketData = malloc(sizeof(int) * n);
    if (!bucketData) {
        fprintf(stderr, "No space for bucketData!\n");
        exit(EXIT_FAILURE);
    }
    // ### 计算 bucketPos
    // bucket 在 bucketData 中的起始位置
    int bucketPos[BUCKET_COUNT];
    for (int p = 0; p < BUCKET_COUNT; p++) {
        bucketPos[p] = 0;
    }

    // 记录每个桶包含的数的数量
    for (int i = 0; i < n; i++) {
        bucketPos[getBucketIndex(&array[i], exp)]++;
    }

    // 计算 bucketPos（桶是从数组后向前使用。如果是从小到大排序，从先大的数放入桶底。）
    for (int j = 1; j < BUCKET_COUNT; j++) {
        bucketPos[j] += bucketPos[j - 1];
    }

    // ### 从 9 到 0 桶且从桶底到桶顶遍历。这样就可以将大的数放入桶底。
    int bucketIndex;
    for (int k = n - 1; k >= 0; k--) {
        bucketIndex = getBucketIndex(&array[k], exp);
        bucketData[--bucketPos[bucketIndex]] = array[k];
    }

    // ### 将桶的结果放入数组中
    for (int m = 0; m < n; m++) {
        array[m] = bucketData[m];
    }

    // ### 回收内存
    free(bucketData);
}

// ### 获取最大指数
// exp == 1: 表示对个位排序
// exp == 10: 表示对十位排序
// exp == 100: 表示对百位排序
static int getMaxExp(const int* array, int n) {
    // ### 找出最大值
    int max = array[0];
    for (int i = 1; i < n; i++) {
        if (array[i] > max) {
            max = array[i];
        }
    }

    // ### 计算最大指数
    int exp = 1;
    while(max /= 10) {
        exp *= 10;
    }

    return exp;
}

static inline int getBucketIndex(const int* element, int exp) {
    return (*element / exp) % 10;
}

static int checkArrayOrder(const int* array, int n) {
    for (int i = 1; i < n; i++) {
        if (array[i - 1] > array[i]) {
            // debug
            /* printf("[%d, %d] %d: %d, %d",n, n, i, array[i - 1], array[i]); */
            return -1;
        }
    }

    return 0;
}

static void printArray(const int* array, int n) {
    for (int i = 0; i < n; i++) {
        printf("%d\t", array[i]);
    }
    printf("\n");
}

static void genRandomNums(int* outArray, int n, int lower, int upper) {
    srand(time(0));
    int tmpUpper = upper - lower + 1;
    for (int i = 0; i < n; i++) {
        outArray[i] = rand() % tmpUpper + lower;
    }
}

static clock_t getTime() {
    clock_t t = clock();
    if (t == (clock_t)-1) {
        fprintf(stderr, "clock() failed\n");
        exit(EXIT_FAILURE);
    }
    return t;
}

int main() {
    int array[ARRAY_SIZE];
    genRandomNums(array, ARRAY_SIZE, 1, ARRAY_SIZE);

    clock_t start, end, duration;
    start = getTime();
    radixSort(array, ARRAY_SIZE);
    end = getTime();
    // 取上限
    duration = ((end - start) - 1) / CLOCKS_PER_SEC + 1;
    printArray(array, ARRAY_SIZE);
    printf("duration = %lfs\n", (double) duration);

    /* int checkRet = checkArrayOrder(array, ARRAY_SIZE); */
    /* if (checkRet < 0) { */
    /*     fprintf(stderr, "checkRet = %d\n", checkRet); */
    /*     exit(EXIT_FAILURE); */
    /* } */

    return 0;
}
```

## List
### Linked List
#### Single Linked List

```c
// ### 说明
// 链表保留头节点

#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <time.h>

#define ARRAY_SIZE (10000 * 10)

typedef int ElementType;

struct Node;
typedef struct Node* PtrToNode;
typedef PtrToNode Position;
typedef PtrToNode List;

struct Node {
    ElementType element;
    Position next;
};

// 在 position 之后插入
void linkedListInsert(const ElementType* elementPtr, Position position, List list);
void linkedListDelete(const ElementType* elementPtr, List list);
Position linkedListFind(const ElementType* elementPtr, List list);
Position linkedListFindPrevious(const ElementType* elementPtr, List list);
List linkedListCreate();
void linkedListDestroy(List list);
List linkedListEmpty(List list);

inline bool linkedListIsEmpty(List list) {
    return list->next == NULL;
}

static size_t linkedListSize(List list);

static void printArray(const int* array, int n);
static void genRandomNums(int* outArray, int n, int lower, int upper);
static clock_t getTime();

// list 暂时不用
void linkedListInsert(const ElementType* elementPtr, Position position, List list) {
    Position newNode = malloc(sizeof(struct Node));
    if (!newNode) {
        fprintf(stderr, "No space for creating a node");
        exit(EXIT_FAILURE);
    }
    newNode->element = *elementPtr;

    newNode->next = position->next;
    position->next = newNode;
}

void linkedListDelete(const ElementType* elementPtr, List list) {
    Position prePos = linkedListFindPrevious(elementPtr, list);
    // 找到了
    if (prePos) {
        Position curPos = prePos->next;
        prePos->next = curPos->next;
        free(curPos);
    }
}

Position linkedListFind(const ElementType* elementPtr, List list) {
    Position curPos = list->next;
    while (curPos) {
        if (curPos->element == *elementPtr) {
            return curPos;
        }
        curPos = curPos->next;
    }

    return curPos;
}

// 如果找不到则返回 NULL
Position linkedListFindPrevious(const ElementType* elementPtr, List list) {
    Position prePos = list;
    while (prePos->next) {
        if (prePos->next->element == *elementPtr) {
            return prePos;
        }

        prePos = prePos->next;
    }

    return prePos->next;
}

List linkedListCreate() {
    List list = malloc(sizeof(struct Node));
    if (!list) {
        fprintf(stderr, "No space for creating list!\n");
        exit(EXIT_FAILURE);
    }
    list->next = NULL;

    return list;
}

void linkedListDestroy(List list) {
    Position curPos = list;
    Position tmpPos;
    while (curPos) {
        tmpPos = curPos->next;
        free(curPos);
        curPos = tmpPos;
    }
}

List linkedListEmpty(List list) {
    Position curPos = list->next;
    list->next = NULL;
    Position tmpPos;
    while (curPos) {
        tmpPos = curPos->next;
        free(curPos);
        curPos = tmpPos;
    }
    return list;
}

static size_t linkedListSize(List list) {
    size_t size = 0;
    Position curPos = list->next;
    while (curPos) {
        size++;
        curPos = curPos->next;
    }

    return size;
}

void printLinkedList(List list) {
    Position curPos = list->next;
    while (curPos) {
        printf("%d\t", curPos->element);
        curPos = curPos->next;
    }
    printf("\n");
}

void printArray(const int* array, int n) {
    for (int i = 0; i < n; i++) {
        printf("%d\t", array[i]);
    }
    printf("\n");
}

void genRandomNums(int* outArray, int n, int lower, int upper) {
    srand(time(0));
    int tmpUpper = upper - lower + 1;
    for (int i = 0; i < n; i++) {
        outArray[i] = rand() % tmpUpper + lower;
    }
}

clock_t getTime() {
    clock_t t = clock();
    if (t == (clock_t)-1) {
        fprintf(stderr, "clock() failed\n");
        exit(EXIT_FAILURE);
    }
    return t;
}

int main() {
    ElementType array[ARRAY_SIZE];
    genRandomNums(array, ARRAY_SIZE, 1, ARRAY_SIZE);

    clock_t start, end, duration;
    List list = linkedListCreate();
    start = getTime();
    for (int i = 0; i < ARRAY_SIZE; i++) {
        linkedListInsert(&array[i], list, list);
    }
    printf("size of list: %lu\n", linkedListSize(list));

    int increment = (ARRAY_SIZE - 1) / 2 + 1;
    for (int k = 0; k < increment; k++) {
        for (int j = k; j < ARRAY_SIZE; j += increment) {
            linkedListDelete(&array[j], list);
        }
    }
    end = getTime();
    printf("size of list: %lu\n", linkedListSize(list));
    // 取上限
    duration = ((end - start) - 1) / CLOCKS_PER_SEC + 1;
    printf("duration = %lfs\n", (double) duration);

    linkedListDestroy(list);

    return 0;
}
```

```c
// ### 说明
// 链表不保留头节点

#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <time.h>

#define ARRAY_SIZE (10000 * 10)

typedef int ElementType;

struct Node;
struct LinkedList;
typedef struct Node* PtrToNode;
typedef const struct Node* ConstPtrToNode;
typedef PtrToNode Position;
typedef ConstPtrToNode ConstPosition;
typedef struct LinkedList* List;
typedef const struct LinkedList* ConstList;

struct Node {
    ElementType element;
    Position next;
};

struct LinkedList {
    struct Node* theList;
    size_t size;
};

// 在 position 之后插入
void linkedListInsert(const ElementType* elementPtr, Position position, List list);
void linkedListDelete(const ElementType* elementPtr, List list);
Position linkedListFind(const ElementType* elementPtr, List list);
// 如果找不到则返回 NULL。如果在第一个节点中，则返回第一个节点。
Position linkedListFindPrevious(const ElementType* elementPtr, List list);
List linkedListCreate();
void linkedListDestroy(List list);
List linkedListEmpty(List list);

inline bool linkedListIsEmpty(ConstList list) {
    return !list->size;
}

static size_t linkedListSize(ConstList list);

// list 暂时不用
void linkedListInsert(const ElementType* elementPtr, Position position, List list) {
    Position newNode = malloc(sizeof(struct Node));
    if (!newNode) {
        fprintf(stderr, "No space for creating a node");
        exit(EXIT_FAILURE);
    }
    newNode->element = *elementPtr;

    if (position) {
        newNode->next = position->next;
        position->next = newNode;
    } else {
        newNode->next = NULL;
        list->theList = newNode;
    }
    list->size++;
}

void linkedListDelete(const ElementType* elementPtr, List list) {
    Position prePos = linkedListFindPrevious(elementPtr, list);

    // ### 找不到
    if (!prePos) {
        return;
    }

    // ### 找到了
    Position curPos;
    if (prePos != (Position) -1) {     // 元素不在第一个节点
        curPos = prePos->next;
        prePos->next = curPos->next;
    } else {                            // 元素在第一个节点
        curPos = list->theList;
        list->theList = curPos->next;
    }
    free(curPos);

    list->size--;
}

Position linkedListFind(const ElementType* elementPtr, List list) {
    Position curPos = list->theList;
    while (curPos) {
        if (curPos->element == *elementPtr) {
            return curPos;
        }
        curPos = curPos->next;
    }

    return NULL;
}

Position linkedListFindPrevious(const ElementType* elementPtr, List list) {
    if (!list->theList) {
        return NULL;
    }

    // 如果在第一个 node 内
    if (list->theList->element == *elementPtr) {
        return (Position) -1;
    }

    Position prePos = list->theList;
    while (prePos->next) {
        if (prePos->next->element == *elementPtr) {
            return prePos;
        }

        prePos = prePos->next;
    }

    return NULL;
}

List linkedListCreate() {
    List list = malloc(sizeof(struct LinkedList));
    if (!list) {
        fprintf(stderr, "No space for creating list!\n");
        exit(EXIT_FAILURE);
    }
    list->theList = NULL;
    list->size = 0;

    return list;
}

void linkedListDestroy(List list) {
    Position curPos = list->theList;
    Position tmpPos;
    while (curPos) {
        tmpPos = curPos->next;
        free(curPos);
        curPos = tmpPos;
    }

    free(list);
}

List linkedListEmpty(List list) {
    Position curPos = list->theList;
    list->theList = NULL;
    Position tmpPos;
    while (curPos) {
        tmpPos = curPos->next;
        free(curPos);
        curPos = tmpPos;
    }
    list->size = 0;

    return list;
}

static size_t linkedListSize(ConstList list) {
    return list->size;
}

void printLinkedList(ConstList list) {
    ConstPosition curPos = list->theList;
    while (curPos) {
        printf("%d\t", curPos->element);
        curPos = curPos->next;
    }
    printf("\n");
}

void printArray(const int* array, int n) {
    for (int i = 0; i < n; i++) {
        printf("%d\t", array[i]);
    }
    printf("\n");
}

void genRandomNums(int* outArray, int n, int lower, int upper) {
    srand(time(0));
    int tmpUpper = upper - lower + 1;
    for (int i = 0; i < n; i++) {
        outArray[i] = rand() % tmpUpper + lower;
    }
}

clock_t getTime() {
    clock_t t = clock();
    if (t == (clock_t)-1) {
        fprintf(stderr, "clock() failed\n");
        exit(EXIT_FAILURE);
    }
    return t;
}

int main() {
    ElementType array[ARRAY_SIZE];
    genRandomNums(array, ARRAY_SIZE, 1, ARRAY_SIZE);

    clock_t start, end, duration;
    List list = linkedListCreate();
    start = getTime();
    for (int i = 0; i < ARRAY_SIZE; i++) {
        linkedListInsert(&array[i], list->theList, list);
    }
    printf("size of list: %lu\n", linkedListSize(list));

    int increment = (ARRAY_SIZE - 1) / 2 + 1;
    for (int k = 0; k < increment; k++) {
        for (int j = k; j < ARRAY_SIZE; j += increment) {
            linkedListDelete(&array[j], list);
        }
    }
    end = getTime();
    printf("size of list: %lu\n", linkedListSize(list));

    // 取上限
    duration = ((end - start) - 1) / CLOCKS_PER_SEC + 1;
    printf("duration = %lfs\n", (double) duration);

    linkedListDestroy(list);

    return 0;
}
```
#### Double Linked List

```c
// ### 说明
// 链表保留头节点
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <time.h>

#define ARRAY_SIZE (10000 * 10)

typedef int ElementType;

struct Node;
typedef struct Node* PtrToNode;
typedef PtrToNode Position;
typedef PtrToNode List;

struct Node {
    ElementType element;
    Position prev;
    Position next;
};

// 在 position 之后插入
void doubleLinkedListInsertAfter(const ElementType* elementPtr, Position position, List list);
// 在 position 之前插入
void doubleLinkedListInsertPrev(const ElementType* elementPtr, Position position, List list);
void doubleLinkedListDelete(const ElementType* elementPtr, List list);
Position doubleLinkedListFind(const ElementType* elementPtr, List list);
List doubleLinkedListCreate();
void doubleLinkedListDestroy(List list);
List doubleLinkedListEmpty(List list);

inline bool doubleLinkedListIsEmpty(List list) {
    return list->next == NULL;
}

static size_t doubleLinkedListSize(List list);

void doubleLinkedListInsertAfter(const ElementType* elementPtr, Position position, List list) {
    Position newNode = malloc(sizeof(struct Node));
    if (!newNode) {
        fprintf(stderr, "No space for creating a node");
        exit(EXIT_FAILURE);
    }
    newNode->element = *elementPtr;

    newNode->next = position->next;
    if (position->next) {
        position->next->prev = newNode;
    }
    position->next = newNode;
    newNode->prev = position;
}

void doubleLinkedListInsertPrev(const ElementType* elementPtr, Position position, List list) {
    if (!position->prev) {
        fprintf(stderr, "position is header!\n");
        exit(EXIT_FAILURE);
    }

    Position newNode = malloc(sizeof(struct Node));
    if (!newNode) {
        fprintf(stderr, "No space for creating a node");
        exit(EXIT_FAILURE);
    }
    newNode->element = *elementPtr;

    newNode->prev = position->prev;
    position->prev->next = newNode;
    newNode->next = position;
    position->prev = newNode;
}

void doubleLinkedListDelete(const ElementType* elementPtr, List list) {
    Position curPos = doubleLinkedListFind(elementPtr, list);
    // 找到了
    if (curPos) {
        Position prePos = curPos->prev;

        prePos->next = curPos->next;
        // 如果不是最后一个节点
        if (curPos->next) {
            curPos->next->prev = prePos;
        }

        free(curPos);
    }
}

Position doubleLinkedListFind(const ElementType* elementPtr, List list) {
    Position curPos = list->next;
    while (curPos) {
        if (curPos->element == *elementPtr) {
            return curPos;
        }
        curPos = curPos->next;
    }

    return curPos;
}

List doubleLinkedListCreate() {
    List list = malloc(sizeof(struct Node));
    if (!list) {
        fprintf(stderr, "No space for creating list!\n");
        exit(EXIT_FAILURE);
    }
    list->next = NULL;
    // 从后向前遍历时，判断是否是第一个节点
    list->prev = NULL;

    return list;
}

void doubleLinkedListDestroy(List list) {
    Position curPos = list;
    Position tmpPos;
    while (curPos) {
        tmpPos = curPos->next;
        free(curPos);
        curPos = tmpPos;
    }
}

List doubleLinkedListEmpty(List list) {
    Position curPos = list->next;
    list->next = NULL;
    Position tmpPos;
    while (curPos) {
        tmpPos = curPos->next;
        free(curPos);
        curPos = tmpPos;
    }
    return list;
}

size_t doubleLinkedListSize(List list) {
    size_t size = 0;
    Position curPos = list->next;
    while (curPos) {
        size++;
        curPos = curPos->next;
    }

    return size;
}

void printLinkedList(List list) {
    Position curPos = list->next;
    while (curPos) {
        printf("%d\t", curPos->element);
        curPos = curPos->next;
    }
    printf("\n");
}

void printArray(const int* array, int n) {
    for (int i = 0; i < n; i++) {
        printf("%d\t", array[i]);
    }
    printf("\n");
}

void genRandomNums(int* outArray, int n, int lower, int upper) {
    srand(time(0));
    int tmpUpper = upper - lower + 1;
    for (int i = 0; i < n; i++) {
        outArray[i] = rand() % tmpUpper + lower;
    }
}

clock_t getTime() {
    clock_t t = clock();
    if (t == (clock_t)-1) {
        fprintf(stderr, "clock() failed\n");
        exit(EXIT_FAILURE);
    }
    return t;
}

int main() {
    ElementType array[ARRAY_SIZE];
    genRandomNums(array, ARRAY_SIZE, 1, ARRAY_SIZE);

    clock_t start, end, duration;
    List list = doubleLinkedListCreate();
    start = getTime();
    for (int i = 0; i < ARRAY_SIZE; i++) {
        doubleLinkedListInsertAfter(&array[i], list, list);
    }
    printf("size of list: %lu\n", doubleLinkedListSize(list));

    int increment = (ARRAY_SIZE - 1) / 2 + 1;
    for (int k = 0; k < increment; k++) {
        for (int j = k; j < ARRAY_SIZE; j += increment) {
            doubleLinkedListDelete(&array[j], list);
        }
    }
    end = getTime();
    printf("size of list: %lu\n", doubleLinkedListSize(list));
    // 取上限
    duration = ((end - start) - 1) / CLOCKS_PER_SEC + 1;
    printf("duration = %lfs\n", (double) duration);

    doubleLinkedListDestroy(list);

    return 0;
}
```

#### Circular Linked List

```c
// ### 说明
// 链表保留头节点
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <time.h>

#define ARRAY_SIZE (10000 * 10)

typedef int ElementType;

struct Node;
typedef struct Node* PtrToNode;
typedef PtrToNode Position;
typedef PtrToNode List;

struct Node {
    ElementType element;
    Position prev;
    Position next;
};

// 在 position 之后插入
void cirLinkedListInsertAfter(const ElementType* elementPtr, Position position, List list);
// 在 position 之前插入
void cirLinkedListInsertPrev(const ElementType* elementPtr, Position position, List list);
void cirLinkedListDelete(const ElementType* elementPtr, List list);
Position cirLinkedListFind(const ElementType* elementPtr, List list);
List cirLinkedListCreate();
void cirLinkedListDestroy(List list);
List cirLinkedListEmpty(List list);

inline bool cirLinkedListIsEmpty(List list) {
    return list->next == list;
}

static size_t cirLinkedListSize(List list);

void cirLinkedListInsertAfter(const ElementType* elementPtr, Position position, List list) {
    Position newNode = malloc(sizeof(struct Node));
    if (!newNode) {
        fprintf(stderr, "No space for creating a node");
        exit(EXIT_FAILURE);
    }
    newNode->element = *elementPtr;

    newNode->next = position->next;
    position->next->prev = newNode;
    position->next = newNode;
    newNode->prev = position;
}

void cirLinkedListInsertPrev(const ElementType* elementPtr, Position position, List list) {
    if (!position->prev) {
        fprintf(stderr, "position is header!\n");
        exit(EXIT_FAILURE);
    }

    Position newNode = malloc(sizeof(struct Node));
    if (!newNode) {
        fprintf(stderr, "No space for creating a node");
        exit(EXIT_FAILURE);
    }
    newNode->element = *elementPtr;

    newNode->prev = position->prev;
    position->prev->next = newNode;
    newNode->next = position;
    position->prev = newNode;
}

void cirLinkedListDelete(const ElementType* elementPtr, List list) {
    Position curPos = cirLinkedListFind(elementPtr, list);
    // 找到了
    if (curPos) {
        Position prePos = curPos->prev;

        prePos->next = curPos->next;
        curPos->next->prev = prePos;

        free(curPos);
    }
}

Position cirLinkedListFind(const ElementType* elementPtr, List list) {
    Position curPos = list->next;
    while (curPos != list) {
        if (curPos->element == *elementPtr) {
            return curPos;
        }
        curPos = curPos->next;
    }

    return curPos;
}

List cirLinkedListCreate() {
    List list = malloc(sizeof(struct Node));
    if (!list) {
        fprintf(stderr, "No space for creating list!\n");
        exit(EXIT_FAILURE);
    }
    list->next = list;
    list->prev = list;

    return list;
}

void cirLinkedListDestroy(List list) {
    Position curPos = list->next;
    Position tmpPos;
    while (curPos != list) {
        tmpPos = curPos->next;
        free(curPos);
        curPos = tmpPos;
    }

    free(list);
}

List cirLinkedListEmpty(List list) {
    Position curPos = list->next;
    Position tmpPos;
    while (curPos != list) {
        tmpPos = curPos->next;
        free(curPos);
        curPos = tmpPos;
    }

    list->next = list;
    list->prev = list;

    return list;
}

static size_t cirLinkedListSize(List list) {
    size_t size = 0;
    Position curPos = list->next;
    while (curPos != list) {
        size++;
        curPos = curPos->next;
    }

    return size;
}

void printLinkedList(List list) {
    Position curPos = list->next;
    while (curPos != list) {
        printf("%d\t", curPos->element);
        curPos = curPos->next;
    }
    printf("\n");
}

void printArray(const int* array, int n) {
    for (int i = 0; i < n; i++) {
        printf("%d\t", array[i]);
    }
    printf("\n");
}

void genRandomNums(int* outArray, int n, int lower, int upper) {
    srand(time(0));
    int tmpUpper = upper - lower + 1;
    for (int i = 0; i < n; i++) {
        outArray[i] = rand() % tmpUpper + lower;
    }
}

clock_t getTime() {
    clock_t t = clock();
    if (t == (clock_t)-1) {
        fprintf(stderr, "clock() failed\n");
        exit(EXIT_FAILURE);
    }
    return t;
}

int main() {
    ElementType array[ARRAY_SIZE];
    genRandomNums(array, ARRAY_SIZE, 1, ARRAY_SIZE);

    clock_t start, end, duration;
    List list = cirLinkedListCreate();
    start = getTime();
    for (int i = 0; i < ARRAY_SIZE; i++) {
        cirLinkedListInsertAfter(&array[i], list, list);
    }
    printf("size of list: %lu\n", cirLinkedListSize(list));

    int increment = (ARRAY_SIZE - 1) / 2 + 1;
    for (int k = 0; k < increment; k++) {
        for (int j = k; j < ARRAY_SIZE; j += increment) {
            cirLinkedListDelete(&array[j], list);
        }
    }
    end = getTime();
    printf("size of list: %lu\n", cirLinkedListSize(list));
    // 取上限
    duration = ((end - start) - 1) / CLOCKS_PER_SEC + 1;
    printf("duration = %lfs\n", (double) duration);

    cirLinkedListDestroy(list);

    return 0;
}
```

## Tree
### Basic Tree

```c
#include <stdio.h>
#include <stdlib.h>

typedef int ElementType;

struct Node;
typedef struct Node *PtrToNode;
typedef PtrToNode Position;

struct Tree;
typedef struct TreeStruct* Tree;
typedef const struct TreeStruct* ConstTree;

struct Node {
	ElementType element;
	Position firstChild;		// 第一个儿子
	Position nextSibling;		// 兄弟
};

struct TreeStruct {
    Position theTree;
};

// 作为 Position 的第一个儿子插入
void treeInsert(const ElementType* elementPtr, Position position, Tree tree);
// void treeDelete(Position position, Tree tree);
// Position treeFind(const ElementType* elementPtr, Tree tree);
void treePrint(Position theTree);

void treeInsert(const ElementType* elementPtr, Position position, Tree tree) {
    Position newNode = malloc(sizeof(struct Node));
    if (!newNode) {
        fprintf(stderr, "No space for creating newNode!\n");
        exit(EXIT_FAILURE);
    }
    newNode->element = *elementPtr;
    newNode->firstChild = NULL;

    // ### 作为第一个儿子插入
    newNode->nextSibling = position->firstChild;
    position->firstChild = newNode;
}

void treePrint(Position theTree) {
	if (!theTree) {
        return;
    }

	printf("%c\t", theTree->element);

    // ### 打印儿子的兄弟
	Position siblingPos = theTree->firstChild;
	while (siblingPos) {
		treePrint(siblingPos);
		siblingPos = siblingPos->nextSibling;
	}
}
```

### BinSearchTree（二叉查找树）

```c
// ### 说明
// leftChild < parent < rightChild

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <stdbool.h>

#define ARRAY_SIZE (10000 * 10)

typedef int ElementType;

struct TreeNode;
typedef struct TreeNode *PtrToNode;
typedef PtrToNode BinSearchTree;
typedef PtrToNode Position;

struct TreeNode {
	ElementType element;
	PtrToNode leftChild;
	PtrToNode rightChild;
};

BinSearchTree bstInsert(ElementType element, BinSearchTree binSearchTree);
BinSearchTree bstDelete(ElementType element, BinSearchTree binSearchTree);
Position bstFind(ElementType element, BinSearchTree binSearchTree);
BinSearchTree bstMakeEmpty(BinSearchTree binSearchTree);

static Position bstFindMin(BinSearchTree binSearchTree);
static Position bstFindMax(BinSearchTree binSearchTree);

static void printBst(BinSearchTree binSearchTree);
static int checkBst(BinSearchTree binSearchTree);

static void printArray(const int* array, int n);
static void genRandomNums(int* outArray, int n, int lower, int upper);
static clock_t getTime();

// 不插入相同的值
BinSearchTree bstInsert(ElementType element, BinSearchTree binSearchTree) {
    if (!binSearchTree) {
        Position newNode = malloc(sizeof(struct TreeNode));
        if (!newNode) {
            fprintf(stderr, "No space for newNode!\n");
            exit(EXIT_FAILURE);
        }
        newNode->element = element;
        newNode->leftChild = newNode->rightChild = NULL;

        binSearchTree = newNode;
    } else if (element < binSearchTree->element) {
        binSearchTree->leftChild = bstInsert(element, binSearchTree->leftChild);
    } else if (element > binSearchTree->element) {
        binSearchTree->rightChild = bstInsert(element, binSearchTree->rightChild);
    } else {    // 相同值
        ;
    }

    return binSearchTree;
}

BinSearchTree bstDelete(ElementType element, BinSearchTree binSearchTree) {
    if (!binSearchTree) {
        return NULL;
    }

    if (element < binSearchTree->element) {
        binSearchTree->leftChild = bstDelete(element, binSearchTree->leftChild);
    } else if (element > binSearchTree->element) {
        binSearchTree->rightChild = bstDelete(element, binSearchTree->rightChild);
    } else {    // element == binSearchTree->element
        Position tmpPos;
        if (binSearchTree->leftChild && binSearchTree->rightChild) {    // 有两个儿子
            tmpPos = bstFindMax(binSearchTree->leftChild);
            binSearchTree->element = tmpPos->element;

            binSearchTree->leftChild = bstDelete(tmpPos->element, binSearchTree->leftChild);
        } else {                                                        // 只有一个儿子或没有儿子
            tmpPos = binSearchTree;
            if (!binSearchTree->rightChild) {                       // 没有左儿子或没有儿子
                binSearchTree = binSearchTree->leftChild;
            } else if (!binSearchTree->leftChild) {                 // 没有右儿子或没有左儿子
                binSearchTree = binSearchTree->rightChild;
            } else {                                                // 没有儿子
                ;
            }
            free(tmpPos);
        }
    }

    return binSearchTree;
}

Position bstFind(ElementType element, BinSearchTree binSearchTree) {
    if (!binSearchTree) {
        return NULL;
    }

    Position pos;
    if (element < binSearchTree->element) {
        pos = bstFind(element, binSearchTree->leftChild);
    } else if (element > binSearchTree->element) {
        pos = bstFind(element, binSearchTree->rightChild);
    } else {    // element == binSearchTree->element
        pos = binSearchTree;
    }

    return pos;
}

static Position bstFindMin(BinSearchTree binSearchTree) {
    if (!binSearchTree) {
        return NULL;
    }

    Position curPos = binSearchTree;
    while (curPos->leftChild) {
        curPos = curPos->leftChild;
    }

    return curPos;
}

static Position bstFindMax(BinSearchTree binSearchTree) {
    if (!binSearchTree) {
        return NULL;
    }

    Position curPos = binSearchTree;
    while (curPos->rightChild) {
        curPos = curPos->rightChild;
    }

    return curPos;
}

BinSearchTree bstMakeEmpty(BinSearchTree binSearchTree) {
    if (!binSearchTree) {
        return NULL;
    }

    bstMakeEmpty(binSearchTree->leftChild);
    bstMakeEmpty(binSearchTree->rightChild);
    free(binSearchTree);
    return NULL;
}

// 中序遍历
static void printBinSearchTree(BinSearchTree binSearchTree) {
    if (!binSearchTree) {
        return;
    }

    printBinSearchTree(binSearchTree->leftChild);
    printf("%d\t", binSearchTree->element);
    printBinSearchTree(binSearchTree->rightChild);
}

static void printBst(BinSearchTree binSearchTree) {
    printBinSearchTree(binSearchTree);
    printf("\n");
}

static int checkBst(BinSearchTree binSearchTree) {
    if (!binSearchTree) {
        return 0;
    }

    if (binSearchTree->leftChild) {
        if (binSearchTree->leftChild->element >= binSearchTree->element) {
            return -1;
        }
    } else if (binSearchTree->rightChild) {
        if (binSearchTree->rightChild->element <= binSearchTree->element) {
            return -2;
        }
    } else {
        return 0;
    }

    int checkRet = checkBst(binSearchTree->leftChild);
    if (checkRet < 0) {
        return checkRet;
    }

    checkRet = checkBst(binSearchTree->rightChild);
    if (checkRet < 0) {
        return checkRet;
    }

    return 0;
}

static void printArray(const int* array, int n) {
    for (int i = 0; i < n; i++) {
        printf("%d\t", array[i]);
    }
    printf("\n");
}

static void genRandomNums(int* outArray, int n, int lower, int upper) {
    srand(time(0));
    int tmpUpper = upper - lower + 1;
    for (int i = 0; i < n; i++) {
        outArray[i] = rand() % tmpUpper + lower;
    }
}

static clock_t getTime() {
    clock_t t = clock();
    if (t == (clock_t)-1) {
        fprintf(stderr, "clock() failed\n");
        exit(EXIT_FAILURE);
    }
    return t;
}

void testBst() {
    int array[ARRAY_SIZE];
    genRandomNums(array, ARRAY_SIZE, 100, ARRAY_SIZE + 999);
    /* printArray(array, ARRAY_SIZE); */

	BinSearchTree binSearchTree = NULL;
    int center = ARRAY_SIZE / 2;
    clock_t start, end, duration;
    start = getTime();
	for (int i = center; i >= 0; i--) {
		binSearchTree = bstInsert(array[i], binSearchTree);
	}
    for (int j = center + 1; j < ARRAY_SIZE; j++) {
		binSearchTree = bstInsert(array[j], binSearchTree);
    }
    /* int checkRet = checkBst(binSearchTree); */
    /* if (checkRet < 0) { */
    /*     fprintf(stderr, "checkRet: %d\n", checkRet); */
    /*     exit(EXIT_FAILURE); */
    /* } */
    /* printBst(binSearchTree); */
	printf("Result of bstFindMin is %d\n", bstFindMin(binSearchTree)->element);
	printf("Result of bstFindMax is %d\n", bstFindMax(binSearchTree)->element);

    for (int q = 0; q < ARRAY_SIZE; q++) {
        binSearchTree = bstDelete(array[q], binSearchTree);
        /* checkRet = checkBst(binSearchTree); */
        /* if (checkRet < 0) { */
        /*     fprintf(stderr, "checkRet: %d\n", checkRet); */
        /*     exit(EXIT_FAILURE); */
        /* } */
    }
    printBst(binSearchTree);
    end = getTime();
    // 取上限
    duration = ((end - start) - 1) / CLOCKS_PER_SEC + 1;
    printf("duration = %lfs\n", (double) duration);
}

int main() {
	testBst();

	return 0;
}
```

### AVL Tree（自平衡二叉查找树）

```c
// ### 说明
// 父子之间的大小：LeftChild < Parent < RightChild
// Height(LeftChild) Height(RightChild) 小于等于 1

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <stdbool.h>

#define ARRAY_SIZE (10000 * 1)

typedef int ElementType;

struct AvlNode;
typedef struct AvlNode* PtrToNode;
typedef PtrToNode Position;
typedef PtrToNode AvlTree;

struct AvlNode {
    ElementType element;
    PtrToNode leftChild;
    PtrToNode rightChild;
    int height;
};

AvlTree avlTreeInsert(ElementType element, AvlTree avlTree);
AvlTree avlTreeDelete(ElementType element, AvlTree avlTree);
Position avlTreeFind(ElementType element, AvlTree avlTree);
Position avlTreeFindMin(AvlTree avlTree);
Position avlTreeFindMax(AvlTree avlTree);
int avlTreeHeight(AvlTree avlTree);
AvlTree avlTreeMakeEmpty(AvlTree avlTree);

static inline Position avlTreeSingleRotateWithLeft(Position k2);
static inline Position avlTreeSingleRotateWithRight(Position k2);
static inline Position avlTreeDoubleRotateWithLeft(Position k3);
static inline Position avlTreeDoubleRotateWithRight(Position k3);
static inline int max(int a, int b);

static void printAvlTreeInOrder(AvlTree avlTree);
static void printAvlTree(AvlTree avlTree);
static int checkAvlTree(AvlTree avlTree);

AvlTree avlTreeInsert(ElementType element, AvlTree avlTree) {
    if (!avlTree) {
        avlTree = malloc(sizeof(struct AvlNode));
        if (!avlTree) {
            fprintf(stderr, "No space for newNode!\n");
            exit(EXIT_FAILURE);
        }
        avlTree->element = element;
        avlTree->height = 0;
        avlTree->leftChild = avlTree->rightChild = NULL;
        return avlTree;
    }

    if (element < avlTree->element) {
        avlTree->leftChild = avlTreeInsert(element, avlTree->leftChild);
    } else if (element > avlTree->element) {
        avlTree->rightChild = avlTreeInsert(element, avlTree->rightChild);
    } else {
        return avlTree;
    }
    avlTree->height = max(avlTreeHeight(avlTree->leftChild), avlTreeHeight(avlTree->rightChild)) + 1;

    // ### 旋转调整
    int diff = avlTreeHeight(avlTree->leftChild) - avlTreeHeight(avlTree->rightChild);
    if (diff == 2) {
        if (element < avlTree->leftChild->element) {        // 左子树一定不为空，因为高度差为 2。
            avlTree = avlTreeSingleRotateWithLeft(avlTree);
        } else {    // 不可能是相等的情况，因为相等则表示左子树为空或左子树旋转了，而不会出现高度差为 2，所以不可能是相等的。
            avlTree = avlTreeDoubleRotateWithLeft(avlTree);
        }
    } else if (diff == -2) {
        if (element > avlTree->rightChild->element) {
            avlTree = avlTreeSingleRotateWithRight(avlTree);
        } else {
            avlTree = avlTreeDoubleRotateWithRight(avlTree);
        }
    } else {
        ;
    }

    return avlTree;
}

// 与 `insert` 同理
AvlTree avlTreeDelete(ElementType element, AvlTree avlTree) {
    if (!avlTree) {
        return NULL;
    }

    if (element < avlTree->element) {
        avlTree->leftChild = avlTreeDelete(element, avlTree->leftChild);
    } else if (element > avlTree->element) {
        avlTree->rightChild = avlTreeDelete(element, avlTree->rightChild);
    } else {
        Position tmpPos;
        if (avlTree->leftChild && avlTree->rightChild) {    // 有两个儿子
            tmpPos = avlTreeFindMax(avlTree->leftChild);
            avlTree->element = tmpPos->element;
            avlTree->leftChild = avlTreeDelete(tmpPos->element, avlTree->leftChild);
        } else {    // 只有一个儿子或没有儿子
            tmpPos = avlTree;
            if (avlTree->leftChild) {
                avlTree = avlTree->leftChild;
                avlTree->height -= 1;
            } else if (avlTree->rightChild) {
                avlTree = avlTree->rightChild;
                avlTree->height -= 1;
            } else {    // 没有儿子
                avlTree = NULL;
            }
            free(tmpPos);
            return avlTree;
        }
    }
    avlTree->height = max(avlTreeHeight(avlTree->leftChild), avlTreeHeight(avlTree->rightChild)) + 1;

    // ### 旋转调整
    // #### 计算 diff（保留四个底层的 diff，为了不重复计算高度）
    int diff, diffLeft, diffRight, diffLeftLeft, diffLeftRight, diffRightLeft, diffRightRight;
    if (avlTree->leftChild) {
        diffLeftLeft = avlTreeHeight(avlTree->leftChild->leftChild);
        diffLeftRight = avlTreeHeight(avlTree->leftChild->rightChild);
    } else {
        diffLeftLeft = -2;
        diffLeftRight = -2;
    }
    diffLeft = max(diffLeftLeft, diffLeftRight) + 1;

    if (avlTree->rightChild) {
        diffRightLeft = avlTreeHeight(avlTree->rightChild->leftChild);
        diffRightRight = avlTreeHeight(avlTree->rightChild->rightChild);
    } else {
        diffRightLeft = -2;
        diffRightRight = -2;
    }
    diffRight = max(diffRightLeft, diffRightRight) + 1;

    // #### 高度超 1 则旋转调整
    diff = diffLeft - diffRight;
    if (diff == 2) {
        if (diffLeftLeft >= diffLeftRight) {    // 如果相等则单双旋转都可以
            avlTree = avlTreeSingleRotateWithLeft(avlTree);
        } else {
            avlTree = avlTreeDoubleRotateWithLeft(avlTree);
        }
    } else if (diff == -2) {
        if (diffRightLeft <= diffRightRight) {
            avlTree = avlTreeSingleRotateWithRight(avlTree);
        } else {
            avlTree = avlTreeDoubleRotateWithRight(avlTree);
        }
    } else {
        ;
    }

    return avlTree;
}

// 标号：最底的结点为 k1, 往上是 k2, k3...
// k1 不为空
static inline Position avlTreeSingleRotateWithLeft(Position k2) {
    Position k1 = k2->leftChild;
    k2->leftChild = k1->rightChild;
    k1->rightChild = k2;

    k2->height = max(avlTreeHeight(k2->leftChild), avlTreeHeight(k2->rightChild)) + 1;
    k1->height = max(avlTreeHeight(k1->leftChild), avlTreeHeight(k1->rightChild)) + 1;
    return k1;
}

static inline Position avlTreeSingleRotateWithRight(Position k2) {
    Position k1 = k2->rightChild;
    k2->rightChild = k1->leftChild;
    k1->leftChild = k2;

    k2->height = max(avlTreeHeight(k2->leftChild), avlTreeHeight(k2->rightChild)) + 1;
    k1->height = max(avlTreeHeight(k1->leftChild), avlTreeHeight(k1->rightChild)) + 1;
    return k1;
}

static inline Position avlTreeDoubleRotateWithLeft(Position k3) {
    k3->leftChild = avlTreeSingleRotateWithRight(k3->leftChild);
    return avlTreeSingleRotateWithLeft(k3);
}

static inline Position avlTreeDoubleRotateWithRight(Position k3) {
    k3->rightChild = avlTreeSingleRotateWithLeft(k3->rightChild);
    return avlTreeSingleRotateWithRight(k3);
}

static inline int max(int a, int b) {
	return a > b ? a : b;
}

Position avlTreeFind(ElementType element, AvlTree avlTree) {
    if (!avlTree) {
        return NULL;
    }

    Position pos;
    if (element < avlTree->element) {
        pos = avlTreeFind(element, avlTree);
    } else if (element > avlTree->element) {
        pos = avlTreeFind(element, avlTree);
    } else {
        pos = avlTree;
    }

    return pos;
}

Position avlTreeFindMin(AvlTree avlTree) {
    if (!avlTree) {
        return NULL;
    }

    Position curPos = avlTree;
    while (curPos->leftChild) {
        curPos = curPos->leftChild;
    }

    return curPos;
}

Position avlTreeFindMax(AvlTree avlTree) {
    if (!avlTree) {
        return NULL;
    }

    Position curPos = avlTree;
    while (curPos->rightChild) {
        curPos = curPos->rightChild;
    }

    return curPos;
}

int avlTreeHeight(AvlTree avlTree) {
    if (!avlTree) {
        return -1;
    }

    return max(avlTreeHeight(avlTree->leftChild), avlTreeHeight(avlTree->rightChild)) + 1;
}

AvlTree avlTreeMakeEmpty(AvlTree avlTree) {
    avlTreeMakeEmpty(avlTree->leftChild);
    avlTreeMakeEmpty(avlTree->rightChild);
    free(avlTree);

    return NULL;
}

// 中序遍历
static void printAvlTreeInOrder(AvlTree avlTree) {
    if (!avlTree) {
        return;
    }

    printAvlTreeInOrder(avlTree->leftChild);
    printf("%d\t", avlTree->element);
    printAvlTreeInOrder(avlTree->rightChild);
}

static void printAvlTree(AvlTree avlTree) {
    printAvlTreeInOrder(avlTree);
    printf("\n");
}

static int checkAvlTree(AvlTree avlTree) {
    if (!avlTree) {
        return 0;
    }

    // ### 检查父结点
    if (avlTree->leftChild) {
        if (avlTree->leftChild->element >= avlTree->element) {
            return -1;
        }
    } else if (avlTree->rightChild) {
        if (avlTree->rightChild->element <= avlTree->element) {
            return -2;
        }
    } else {
        return 0;
    }

    int diff = avlTreeHeight(avlTree->leftChild) - avlTreeHeight(avlTree->rightChild);
    if (diff > 1) {
        return -3;
    } else if (diff < -1) {
        return -4;
    } else {
        ;
    }

    // ### 检查子结点
    int checkRet = checkAvlTree(avlTree->leftChild);
    if (checkRet < 0) {
        return checkRet;
    }
    checkRet = checkAvlTree(avlTree->rightChild);
    if (checkRet < 0) {
        return checkRet;
    }

    return 0;
}

void printArray(int* array, int n) {
    for (int i = 0; i < n; i++) {
        printf("%d\t", array[i]);
    }
    printf("\n");
}

void genRandomNums(int* outArray, int n, int lower, int upper) {
    srand(time(0));
    int tmpUpper = upper - lower + 1;
    for (int i = 0; i < n; i++) {
        outArray[i] = rand() % tmpUpper + lower;
    }
}

clock_t getTime() {
    clock_t t = clock();
    if (t == (clock_t)-1) {
        fprintf(stderr, "clock() failed\n");
        exit(EXIT_FAILURE);
    }
    return t;
}

static void testAvlTree() {
    int array[ARRAY_SIZE];
    genRandomNums(array, ARRAY_SIZE, 100, ARRAY_SIZE + 999);
    /* printArray(array, ARRAY_SIZE); */

	AvlTree avlTree = NULL;
    int center = ARRAY_SIZE / 2;
    clock_t start, end, duration;
    start = getTime();
	for (int i = center; i >= 0; i--) {
		avlTree = avlTreeInsert(array[i], avlTree);
	}
    for (int j = center + 1; j < ARRAY_SIZE; j++) {
		avlTree = avlTreeInsert(array[j], avlTree);
    }
    /* printAvlTree(avlTree); */
	printf("Result of avlTreeFindMin is %d\n", avlTreeFindMin(avlTree)->element);
	printf("Result of avlTreeFindMax is %d\n", avlTreeFindMax(avlTree)->element);
    /* int checkRet = checkAvlTree(avlTree); */
    /* if (checkRet < 0) { */
    /*     fprintf(stderr, "checkRet: %d\n", checkRet); */
    /*     exit(EXIT_FAILURE); */
    /* } */

    for (int q = 0; q < ARRAY_SIZE; q++) {
        avlTree = avlTreeDelete(array[q], avlTree);
        /* checkRet = checkAvlTree(avlTree); */
        /* if (checkRet < 0) { */
        /*     fprintf(stderr, "checkRet: %d\n", checkRet); */
        /*     exit(EXIT_FAILURE); */
        /* } */
    }
    printAvlTree(avlTree);
    end = getTime();
    // 取上限
    duration = ((end - start) - 1) / CLOCKS_PER_SEC + 1;
    printf("duration = %lfs\n", (double) duration);
}

int main() {
	testAvlTree();
	return 0;
}
```

### Splay Tree（伸展树）

```c
// ### 说明
// 父子之间的大小：LeftChild < Parent < RightChild
// 每次执行 Splay(X, H) ，则含 X 的节点被旋转为根节点。
// zig-zag, zag-zig 的旋转的方法与 AVL Tree 相同，而 zig-zig, zag-zag 类似但不同于 AVL Tree。

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define ARRAY_SIZE (10000 * 1)

typedef int ElementType;

struct TreeNode;
typedef struct TreeNode *PtrToNode;
typedef PtrToNode SplayTree;
typedef PtrToNode Position;

struct TreeNode {
	ElementType element;
	PtrToNode leftChild;
	PtrToNode rightChild;
};

Position splayTreeSplay(ElementType element, SplayTree splayTree);
SplayTree splayTreeInsert(ElementType element, SplayTree splayTree);
SplayTree splayTreeDelete(ElementType element, SplayTree splayTree);
SplayTree splayTreeMakeEmpty(SplayTree splayTree);

static inline Position splayTreeSingleRotateWithLeft(Position k2);
static inline Position splayTreeSingleRotateWithRight(Position k2);
static Position splayTreeFindMin(SplayTree splayTree);
static Position splayTreeFindMax(SplayTree splayTree);

static int checkSplayTree(SplayTree splayTree);
static void printSplayTree(SplayTree splayTree);

Position splayTreeSplay(ElementType element, SplayTree splayTree) {
    if (!splayTree || element == splayTree->element) {
        return splayTree;
    }

    if (element < splayTree->element) {
        if (!splayTree->leftChild) {
            return splayTree;
        }

        if (element < splayTree->leftChild->element) {
            splayTree->leftChild->leftChild = splayTreeSplay(element, splayTree->leftChild->leftChild);
            splayTree = splayTreeSingleRotateWithLeft(splayTree);
        } else if (element > splayTree->leftChild->element) {
            splayTree->leftChild->rightChild = splayTreeSplay(element, splayTree->leftChild->rightChild);
            if (splayTree->leftChild->rightChild) {
                splayTree->leftChild = splayTreeSingleRotateWithRight(splayTree->leftChild);
            }
        } else {
            ;
        }
        splayTree = splayTreeSingleRotateWithLeft(splayTree);

        return splayTree->leftChild ? splayTreeSplay(element, splayTree) : splayTree;
    } else {    // element > splayTree->element
        if (!splayTree->rightChild) {
            return splayTree;
        }

        if (element > splayTree->rightChild->element) {
            splayTree->rightChild->rightChild = splayTreeSplay(element, splayTree->rightChild->rightChild);
            splayTree = splayTreeSingleRotateWithRight(splayTree);
        } else if (element < splayTree->rightChild->element) {
            splayTree->rightChild->leftChild = splayTreeSplay(element, splayTree->rightChild->leftChild);
            if (!splayTree->rightChild->leftChild) {
                splayTree->rightChild = splayTreeSingleRotateWithLeft(splayTree->rightChild);
            }
        } else {
            ;
        }

        return splayTree->rightChild ? splayTreeSingleRotateWithRight(splayTree) : splayTree;
    }

    return splayTree;
}

SplayTree splayTreeInsert(ElementType element, SplayTree splayTree) {
    if (!splayTree) {
        Position newNode = malloc(sizeof(struct TreeNode));
        if (!newNode) {
            fprintf(stderr, "No space for newNode!\n");
            exit(EXIT_FAILURE);
        }
        newNode->element = element;
        newNode->leftChild = newNode->rightChild = NULL;

        splayTree = newNode;
    } else if (element < splayTree->element) {
        splayTree->leftChild = splayTreeInsert(element, splayTree->leftChild);
    } else if (element > splayTree->element) {
        splayTree->rightChild = splayTreeInsert(element, splayTree->rightChild);
    } else {    // 相同值
        ;
    }

    return splayTree;
}

SplayTree splayTreeDelete(ElementType element, SplayTree splayTree) {
    if (!splayTree) {
        return NULL;
    }

    if (element < splayTree->element) {
        splayTree->leftChild = splayTreeDelete(element, splayTree->leftChild);
    } else if (element > splayTree->element) {
        splayTree->rightChild = splayTreeDelete(element, splayTree->rightChild);
    } else {    // element == splayTree->element
        Position tmpPos;
        if (splayTree->leftChild && splayTree->rightChild) {    // 有两个儿子
            tmpPos = splayTreeFindMax(splayTree->leftChild);
            splayTree->element = tmpPos->element;

            splayTree->leftChild = splayTreeDelete(tmpPos->element, splayTree->leftChild);
        } else {    // 只有一个儿子或没有儿子
            tmpPos = splayTree;
            if (!splayTree->rightChild) {                       // 没有左儿子或没有儿子
                splayTree = splayTree->leftChild;
            } else if (!splayTree->leftChild) {                 // 没有右儿子或没有左儿子
                splayTree = splayTree->rightChild;
            } else {                                                // 没有儿子
                ;
            }
            free(tmpPos);
        }
    }

    return splayTree;
}

// 标号：最底的结点为 k1, 往上是 k2, k3...
// k1 不为空
static inline Position splayTreeSingleRotateWithLeft(Position k2) {
    Position k1 = k2->leftChild;
    k2->leftChild = k1->rightChild;
    k1->rightChild = k2;

    return k1;
}

static inline Position splayTreeSingleRotateWithRight(Position k2) {
    Position k1 = k2->rightChild;
    k2->rightChild = k1->leftChild;
    k1->leftChild = k2;

    return k1;
}

SplayTree splayTreeMakeEmpty(SplayTree splayTree) {
    if (!splayTree) {
        return NULL;
    }

    splayTreeMakeEmpty(splayTree->leftChild);
    splayTreeMakeEmpty(splayTree->rightChild);
    free(splayTree);
    return NULL;
}

static Position splayTreeFindMin(SplayTree splayTree) {
    if (!splayTree) {
        return NULL;
    }

    Position curPos = splayTree;
    while (curPos->leftChild) {
        curPos = curPos->leftChild;
    }

    return curPos;
}

static Position splayTreeFindMax(SplayTree splayTree) {
    if (!splayTree) {
        return NULL;
    }

    Position curPos = splayTree;
    while (curPos->rightChild) {
        curPos = curPos->rightChild;
    }

    return curPos;
}

static void printSplayTreeInOrder(SplayTree splayTree) {
    if (!splayTree) {
        return;
    }

    printSplayTreeInOrder(splayTree->leftChild);
    printf("%d\t", splayTree->element);
    printSplayTreeInOrder(splayTree->rightChild);
}

static void printSplayTree(SplayTree splayTree) {
    printSplayTreeInOrder(splayTree);
    printf("\n");
}

static int checkSplayTree(SplayTree splayTree) {
    if (!splayTree) {
        return 0;
    }

    if (splayTree->leftChild) {
        if (splayTree->leftChild->element >= splayTree->element) {
            return -1;
        }
    } else if (splayTree->rightChild) {
        if (splayTree->rightChild->element <= splayTree->element) {
            return -2;
        }
    } else {
        return 0;
    }

    int checkRet = checkSplayTree(splayTree->leftChild);
    if (checkRet < 0) {
        return checkRet;
    }

    checkRet = checkSplayTree(splayTree->rightChild);
    if (checkRet < 0) {
        return checkRet;
    }

    return 0;
}

void printArray(int* array, int n) {
    for (int i = 0; i < n; i++) {
        printf("%d\t", array[i]);
    }
    printf("\n");
}

void genRandomNums(int* outArray, int n, int lower, int upper) {
    srand(time(0));
    int tmpUpper = upper - lower + 1;
    for (int i = 0; i < n; i++) {
        outArray[i] = rand() % tmpUpper + lower;
    }
}

clock_t getTime() {
    clock_t t = clock();
    if (t == (clock_t)-1) {
        fprintf(stderr, "clock() failed\n");
        exit(EXIT_FAILURE);
    }
    return t;
}

void testSplayTree() {
    int array[ARRAY_SIZE];
    genRandomNums(array, ARRAY_SIZE, 100, ARRAY_SIZE + 999);
    /* printArray(array, ARRAY_SIZE); */

	SplayTree splayTree = NULL;
    int center = ARRAY_SIZE / 2;
    clock_t start, end, duration;
    start = getTime();
	for (int i = center; i >= 0; i--) {
		splayTree = splayTreeInsert(array[i], splayTree);
	}
    for (int j = center + 1; j < ARRAY_SIZE; j++) {
		splayTree = splayTreeInsert(array[j], splayTree);
    }
    /* int checkRet = checkSplayTree(splayTree); */
    /* if (checkRet < 0) { */
    /*     fprintf(stderr, "checkRet: %d\n", checkRet); */
    /*     exit(EXIT_FAILURE); */
    /* } */
    /* printSplayTree(splayTree); */
	printf("Result of bstFindMin is %d\n", splayTreeFindMin(splayTree)->element);
	printf("Result of bstFindMax is %d\n", splayTreeFindMax(splayTree)->element);

    for (int q = 0; q < ARRAY_SIZE; q++) {
        splayTree = splayTreeDelete(array[q], splayTree);
        /* checkRet = checkSplayTree(splayTree); */
        /* if (checkRet < 0) { */
        /*     fprintf(stderr, "checkRet: %d\n", checkRet); */
        /*     exit(EXIT_FAILURE); */
        /* } */
    }
    printSplayTree(splayTree);
    end = getTime();
    // 取上限
    duration = ((end - start) - 1) / CLOCKS_PER_SEC + 1;
    printf("duration = %lfs\n", (double) duration);

    splayTree = splayTreeMakeEmpty(splayTree);
}

int main() {
	testSplayTree();
	return 0;
}
```

### BTree（多路搜索树）

`B` 是 balance 的简称。

```c
/************************************************************************************
### References

-   <https://www.geeksforgeeks.org/introduction-of-b-tree-2/>
-   <https://www.geeksforgeeks.org/insert-operation-in-b-tree/>
-   <https://www.geeksforgeeks.org/delete-operation-in-b-tree/>

### Btree 性质

[两种流行的定义](https://stackoverflow.com/a/45826413)
[多种定义](https://www.zhihu.com/question/19836260)
[wiki](https://en.wikipedia.org/wiki/B-tree#Definition)

> 一个用阶来描述 `min <= children <= max` 而另一个用最小度数。  
> 它们的区别是，`CLRS Degree (Degree)` 对应的阶只能是偶数。

*internal node（内部结点）：非叶子结点。*

#### Knuth's Definition

设 Btree 的阶（Order）为 M。

叶子结点：指向叶子结点的指针为 NULL。

1. 树中每一个结点至多有 M 棵子树；
2. 若根结点不是叶子结点，则至少有两棵子树；
3. 除根结点之外的所有非终端结点（内部节点）至少有 `ceil(M/2)` 棵子树；
4. 左儿子的 key < key < 右儿子的 key。
5. 所有的叶子结点都出现在同一层次上，并且不带信息。

#### CLRS（算法导论）

*对 Knuth 的改进。*

设 BTree 的最小度数（minimum Degree）为 t (t >= 2)。

叶子结点：指向儿子的指针都为 NULL 的结点。

1. 每个结点（除了 root）有 [t - 1, 2t - 1] 个 keys；
2. 每个内部结点（除了根节点）有 [t, 2t] 个儿子。
3. 当 BTree 不为空时，根节点至少有 1 个 key。至多有 2t 儿子。
4. 左儿子的 key <= key <= 右儿子的 key。
5. 所有的叶子结点都有同样的深度，与树的高度相同。

### 操作

如何保持叶子节点在同一深度:  
> 插入满时，分裂。 删除时，key < t 时，合并。所以不会造成左右儿子深度不一。

#### 三个基本的操作

-   分裂

    如果本节点不满而有一个儿子满时，可分裂儿子。将儿子的 keys[t - 1] 拿出，则儿子刚好平分。将儿子的 keys[t - 1] 插入到本节点，再将儿子的右半部分作为 keys[t - 1] 的右儿子即可。

-   合并

    如果本节点 keyCount >= t 且 keys[idx] 的左右儿子的 keyCount = t - 1 时，可将 keys[idx] 及其左右儿子合并为一个满的节点，再将作为 keys[idx] 的左儿子, 删除 keys[idx] 及其右儿子即可。

-   向兄弟借一个 key 和 child

    如果兄弟的 keyCount >= t 可向兄弟借一个 key 和 child。

    分为两个情况：

    -   向左兄弟借

        设 curChild = childs[idx], 则 prevChild = childs[idx - 1]。所以有 prevChild <= keys[idx - 1] <= curChild。  
        curChild 右移空出 childs[0], keys[0]。 keys[idx - 1] 和 prevChild 最右的儿子补入。再将 prevChild 最右的 key 插入到 keys[idx - 1]。

    -   向右兄弟借

        与`向左兄弟借`同理。

#### 插入的递归操作

前提本节点不满。  
如果本节点是叶子结点，则插入。如果不是叶子则向儿子插入。如果儿子是满的则分裂儿子再插入。所以最终结果是优先向儿子插入（最终插入到叶子）。

*如果本节点为 root 时，先分裂 root 再插入。*

#### 删除的递归操作：

前提是，如果本节点不是根节点则 `keyCount >= t`，如果是根节点则 `keyCount >= 1`。

如果要删除的 key 在本节点：  
> 如果本节点是叶子结点则直接删除。  
> 如果不是叶子结点，且左右儿子的 `keyCount >= t`，则将左儿子的最大 key 或右儿子的最小 key 复制到本节点，再删除左或右儿子复制的 key。这过程类似二叉查找树的删除。

*如果本节点是 root, 则 keyCount 为 0 时，将第一个儿子作为 root。*

如果要删除的 key 不在本节点：  
> 找到 key 可能所在的 child。如果儿子节点的 `keyCount == t - 1` 则填充儿子，再删除儿子。

##### 填充操作：

前提是，本节点 `keyCount == t - 1`。

如果兄弟 `keyCount >=t`，则向其借一个 key。  
如果兄弟 `keyCount == t - 1`，则与兄弟合并。

### 说明

以下的例子是 CLRS（算法导论）的 BTree

1. 叶子结点的 childs 不初始化为 NULL。
2. 左儿子的 key <= key <= 右儿子的 key。

*********************************************************************************/

#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <time.h>

#define ARRAY_SIZE (10000 * 1)

typedef int KeyType;

struct BTreeNode;
struct BTree;
typedef struct BTreeNodeStruct* PtrToBinTreeNode;
typedef PtrToBinTreeNode BTreeNode;
typedef PtrToBinTreeNode Position;
typedef struct BTreeStruct* PtrToBTree;
typedef PtrToBTree BTree;

struct BTreeNodeStruct {
    KeyType* keys;
    PtrToBinTreeNode* childs;
    int keyCount;
    int t;
    bool isLeaf;
};

struct BTreeStruct {
    BTreeNode root;
    int t;
};

void btreeInsert(KeyType key, BTree btree);
void btreeDelete(KeyType key, BTree btree);
BTree btreeInitialize(int t);
void btreeDestroy(BTree btree);

void btreeNodeInsertNonFull(KeyType key, BTreeNode btreeNode);
void btreeNodeDelete(KeyType key, BTreeNode btreeNode);
void btreeNodeDestroy(BTreeNode btreeNode);

static void btreeNodeSplitChild(int idx, BTreeNode btreeNode);
static void btreeNodeMergeChild(int idx, BTreeNode btreeNode);
static void btreeNodeBorrowFromPrev(int idx, BTreeNode btreeNode);
static void btreeNodeBorrowFromNext(int idx, BTreeNode btreeNode);

static void btreeNodeFillChild(int idx, BTreeNode btreeNode);
static void btreeNodeDeleteFromLeaf(int idx, BTreeNode btreeNode);
static void btreeNodeDeleteFromNonLeaf(int idx, BTreeNode btreeNode);

static BTreeNode btreeNodeCreateNode(bool isLeaf, int t);
static void btreeNodeRightShift(int idx, bool isBaseOnChild, BTreeNode btreeNode);
static int btreeNodeFindIdx(KeyType key, BTreeNode btreeNode);
static bool btreeNodeIsFull(BTreeNode btreeNode);
static KeyType btreeNodeGetMin(BTreeNode btreeNode);
static KeyType btreeNodeGetMax(BTreeNode btreeNode);

static void traverseBTree(BTree btree);
static void traverseBTreeNode(BTreeNode btreeNode, int depth);
static int checkBTree(BTree btree);
static int checkBTreeNode(BTreeNode btreeNode);

static void printArray(const int* array, int n);
static void genRandomNums(int* outArray, int n, int lower, int upper);
static clock_t getTime();

void btreeInsert(KeyType key, BTree btree) {
    if (!btree->root) {
        btree->root = btreeNodeCreateNode(true, btree->t);
        btree->root->keys[0] = key;
        btree->root->keyCount++;
        return;
    }

    if (!btreeNodeIsFull(btree->root)) {     // 本节点不满
        btreeNodeInsertNonFull(key, btree->root);
    } else {    // 本节点已满
        BTreeNode newRoot = btreeNodeCreateNode(false, btree->t);
        newRoot->childs[0]= btree->root;
        btreeNodeSplitChild(0, newRoot);
        btree->root = newRoot;
        btreeNodeInsertNonFull(key, btree->root);
    }
}

void btreeDelete(KeyType key, BTree btree) {
    if (!btree->root) {
        fprintf(stderr, "root is Empty!\n");
        exit(EXIT_FAILURE);
    }

    btreeNodeDelete(key, btree->root);

    if (!btree->root->keyCount) {
        BTreeNode tmpRoot = btree->root;
        if (btree->root->isLeaf) {
            btree->root = NULL;
        } else {
            // btreeNodeDelete 后，已合并 childs[0], childs[1]
            btree->root = btree->root->childs[0];
        }
        free(tmpRoot);
    }
}

BTree btreeInitialize(int t) {
    BTree btree = malloc(sizeof(struct BTreeStruct));
    if (!btree) {
        fprintf(stderr, "No space for creating btree!\n");
        exit(EXIT_FAILURE);
    }
    btree->t = t;
    btree->root = NULL;

    return btree;
}

void btreeDestroy(BTree btree) {
    btreeNodeDestroy(btree->root);
    free(btree);
}

// 前提：本节点不满
// 优先向叶子插入
void btreeNodeInsertNonFull(KeyType key, BTreeNode btreeNode) {
    if (btreeNode->isLeaf) {
        int idx = 0;
        while (idx < btreeNode->keyCount && key >= btreeNode->keys[idx]) {
            idx++;
        }

        // 将 keys[idx] 右边的东西（包含 keys[idx]）右移
        for (int i = btreeNode->keyCount; i > idx; i--) {
            btreeNode->keys[i] = btreeNode->keys[i - 1];
        }
        btreeNode->keys[idx] = key;
        btreeNode->keyCount++;
    } else {
        int idx = btreeNodeFindIdx(key, btreeNode);
        if (btreeNodeIsFull(btreeNode->childs[idx])) {
            btreeNodeSplitChild(idx, btreeNode);

            // 分裂会使本节点新增一个 key 和 child。 keys[idx] 为新增的 key。
            if (key > btreeNode->keys[idx]) {
                idx++;
            }
        }
        btreeNodeInsertNonFull(key, btreeNode->childs[idx]);
    }
}

// 前提：本节点不为根时，keyCount >= t。本节是根节点也是可以的（正好能处理，不过还没有处理完。如果只有一个 key 时，root 要更新，这要在外边处理）。
void btreeNodeDelete(KeyType key, BTreeNode btreeNode) {
    int idx = btreeNodeFindIdx(key, btreeNode);

    // ### key 在本节点
    if (idx < btreeNode->keyCount && btreeNode->keys[idx] == key) {
        if (btreeNode->isLeaf) {
            btreeNodeDeleteFromLeaf(idx, btreeNode);
        } else {
            btreeNodeDeleteFromNonLeaf(idx, btreeNode);
        }
        return;
    }

    // ### key 不在本节点
    if (btreeNode->isLeaf) {
        return;
    }

    // #### key 可能在儿子节点
    bool isLastChild = (idx == btreeNode->keyCount);
    if (btreeNode->childs[idx]->keyCount < btreeNode->t) {
        btreeNodeFillChild(idx, btreeNode);
    }
    // 如果是最后一个儿子且被合并了
    if (isLastChild && idx > btreeNode->keyCount) {
        btreeNodeDelete(key, btreeNode->childs[idx - 1]);
    } else {
        btreeNodeDelete(key, btreeNode->childs[idx]);
    }
}

void btreeNodeDestroy(BTreeNode btreeNode) {
    if (!btreeNode) {
        return;
    }

    for (int i = 0; i <= btreeNode->keyCount; i++) {
        btreeNodeDestroy(btreeNode->childs[i]);
    }
    free(btreeNode->keys);
    free(btreeNode->childs);
    free(btreeNode);
}

// 前提：keyCount >= t
static void btreeNodeDeleteFromLeaf(int idx, BTreeNode btreeNode) {
    for (int i = idx + 1; i < btreeNode->keyCount; i++) {
        btreeNode->keys[i - 1] = btreeNode->keys[i];
    }
    btreeNode->keyCount--;
}

// 前提：keyCount >= t
static void btreeNodeDeleteFromNonLeaf(int idx, BTreeNode btreeNode) {
    if (btreeNode->childs[idx]->keyCount >= btreeNode->t) {
        KeyType maxKey = btreeNodeGetMax(btreeNode->childs[idx]);
        btreeNode->keys[idx] = maxKey;
        btreeNodeDelete(maxKey, btreeNode->childs[idx]);
    } else if (btreeNode->childs[idx + 1]->keyCount >= btreeNode->t) {
        KeyType minKey = btreeNodeGetMin(btreeNode->childs[idx + 1]);
        btreeNode->keys[idx] = minKey;
        btreeNodeDelete(minKey, btreeNode->childs[idx + 1]);
    } else {
        int key = btreeNode->keys[idx];
        btreeNodeMergeChild(idx, btreeNode);
        btreeNodeDelete(key, btreeNode->childs[idx]);
    }
}

// 前提：本节点不满，childs[idx] 是满的
// keys: [0, t - 1), [t - 1], [t, 2t - 1). 将 keys[t - 1] 抽出，则刚好平分。将本节点的 keys[idx], childs[idx + 1] 空出，再将 keys[t - 1], newRightNode 插入即可。
static void btreeNodeSplitChild(int idx, BTreeNode btreeNode) {
    BTreeNode splitedChild = btreeNode->childs[idx];

    // ### 将 childs[idx] 右半部分放入 newRightChild
    BTreeNode newRightNode = btreeNodeCreateNode(splitedChild->isLeaf, btreeNode->t);
    for (int i = 0; i < splitedChild->t - 1; i++) {
        newRightNode->keys[i] = splitedChild->keys[i + splitedChild->t];
    }
    if (!splitedChild->isLeaf) {
        for (int j = 0; j < splitedChild->t; j++) {
            newRightNode->childs[j] = splitedChild->childs[j + splitedChild->t];
        }
    }
    // 更新 newRightNode->keyCount
    newRightNode->keyCount = btreeNode->t - 1;

    // ### 空出 keys[idx], childs[idx + 1]
    btreeNodeRightShift(idx, false, btreeNode);

    // ### 本节点插入 keys[t - 1], newRightNode
    btreeNode->keys[idx] = splitedChild->keys[splitedChild->t - 1];
    btreeNode->childs[idx + 1] = newRightNode;

    // 更新本节点与 childs[idx] 的 keyCount
    btreeNode->keyCount++;
    splitedChild->keyCount = splitedChild->t - 1;
}

// 填充 childs[idx]
// 前提：child[idx]->keyCount == t - 1
static void btreeNodeFillChild(int idx, BTreeNode btreeNode) {
    if (idx != 0 && btreeNode->childs[idx - 1]->keyCount >= btreeNode->t) {
        btreeNodeBorrowFromPrev(idx, btreeNode);
    } else if (idx != btreeNode->keyCount && btreeNode->childs[idx + 1]->keyCount >= btreeNode->t) {
        btreeNodeBorrowFromNext(idx, btreeNode);
    } else {    // (idx == 0 || childs[idx - 1]->keyCount < t) && (idx == keyCount || childs[idx + 1] < t)
        if (idx != btreeNode->keyCount) {   // childs[idx + 1]->keyCount < t
            btreeNodeMergeChild(idx, btreeNode);
        } else {    // childs[idx - 1]->keyCount < t
            btreeNodeMergeChild(idx- 1, btreeNode);
        }
    }
}

// 合并 keys[idx] 的左右儿子
// 前提：childs[idx], childs[idx + 1] 的 keyCount == t - 1; 本节点 keyCount >= t
static void btreeNodeMergeChild(int idx, BTreeNode btreeNode) {
    Position leftChild = btreeNode->childs[idx];
    Position rightChild = btreeNode->childs[idx + 1];

    // ### keys[idx] 加入 leftChild
    leftChild->keys[btreeNode->t - 1] = btreeNode->keys[idx];

    // ### rightChild 加入 leftchild
    for (int i = 0; i < btreeNode->t - 1; i++) {
        leftChild->keys[i + btreeNode->t] = rightChild->keys[i];
        leftChild->childs[i + btreeNode->t] = rightChild->childs[i];
    }
    leftChild->childs[2 * btreeNode->t - 1] = rightChild->childs[rightChild->keyCount];

    // ### 本节点左移
    for (int i = idx + 1; i < btreeNode->keyCount; i++) {
        btreeNode->keys[i - 1] = btreeNode->keys[i];
        btreeNode->childs[i] = btreeNode->childs[i + 1];
    }

    // ### 更新
    btreeNode->keyCount--;
    leftChild->keyCount += rightChild->keyCount + 1;
    free(rightChild);
}

static BTreeNode btreeNodeCreateNode(bool isLeaf, int t) {
    BTreeNode btreeNode = malloc(sizeof(struct BTreeNodeStruct));
    if (!btreeNode) {
        fprintf(stderr, "No space for creating btreeNode!\n");
        exit(EXIT_FAILURE);
    }
    btreeNode->keys = malloc(sizeof(KeyType) * (2 * t - 1));
    if (!btreeNode->keys) {
        fprintf(stderr, "No space for creating btreeNode->keys!\n");
        exit(EXIT_FAILURE);
    }
    btreeNode->childs = malloc(sizeof(btreeNode) * (2 * t));
    if (!btreeNode->childs) {
        fprintf(stderr, "No space for creating btreeNode->childs!\n");
        exit(EXIT_FAILURE);
    }
    btreeNode->keyCount = 0;
    btreeNode->isLeaf = isLeaf;
    btreeNode->t = t;

    return btreeNode;
}

// 前提：本节点不满
// 基于 keys[idx] 或 childs[idx], 将其右边（包含自身）的 keys, childs 右移。
// isBaseOnChild 表示基于 childs[idx], 否则基于 keys[idx]
static void btreeNodeRightShift(int idx, bool isBaseOnChild, BTreeNode btreeNode) {
    // 将 keys[idx] 右边的东西右移
    for (int i = btreeNode->keyCount; i > idx; i--) {
        btreeNode->keys[i] = btreeNode->keys[i - 1];
        btreeNode->childs[i + 1] = btreeNode->childs[i];
    }

    if (isBaseOnChild) {
        btreeNode->childs[idx + 1] = btreeNode->childs[idx];
    }
}

// 如果 btreeNode 有相同的 key, 则返回其 key 的 idx, 否则返回 key 所在的 child 的 idx
static int btreeNodeFindIdx(KeyType key, BTreeNode btreeNode) {
    int idx = 0;
    while (idx < btreeNode->keyCount && key > btreeNode->keys[idx]) {
        idx++;
    }
    return idx;
}

static bool btreeNodeIsFull(BTreeNode btreeNode) {
    return btreeNode->keyCount == 2 * btreeNode->t - 1;
}

static KeyType btreeNodeGetMax(BTreeNode btreeNode) {
    Position cur = btreeNode;
    while (!cur->isLeaf) {
        cur = cur->childs[cur->keyCount];
    }

    return cur->keys[cur->keyCount - 1];
}

static KeyType btreeNodeGetMin(BTreeNode btreeNode) {
    Position cur = btreeNode;
    while (!cur->isLeaf) {
        cur = cur->childs[0];
    }

    return cur->keys[0];
}

// 前提: idx 不为 0; childs[idx - 1]->keyCount >= t
// prevSibling->keys[keyCount - 1] <= prevSibling->childs[keyCount] <= keys[idx - 1] <= childs[idx]。prevSibling->childs[keyCount] 和 key[idx - 1] 加入 childs[idx], prevSibling->keys[keyCount - 1] 加入 keys[idx] 即可。
static void btreeNodeBorrowFromPrev(int idx, BTreeNode btreeNode) {
    Position prevSibling = btreeNode->childs[idx - 1];
    Position curChild = btreeNode->childs[idx];

    btreeNodeRightShift(0, true, curChild);

    // ### keys
    curChild->keys[0] = btreeNode->keys[idx - 1];
    btreeNode->keys[idx - 1] = prevSibling->keys[prevSibling->keyCount - 1];

    // ### the child
    curChild->childs[0] = prevSibling->childs[prevSibling->keyCount];

    // ### 更新 keyCount
    prevSibling->keyCount--;
    curChild->keyCount++;
}

// 前提: idx 不为 keyCount; childs[idx + 1]->keyCount >= t
static void btreeNodeBorrowFromNext(int idx, BTreeNode btreeNode) {
    Position nextSibling = btreeNode->childs[idx + 1];
    Position curChild = btreeNode->childs[idx];

    // ### keys
    curChild->keys[curChild->keyCount] = btreeNode->keys[idx];
    btreeNode->keys[idx] = nextSibling->keys[0];

    // ### the child
    curChild->childs[curChild->keyCount + 1] = nextSibling->childs[0];

    // ### nextSibling 左移
    for (int i = 1; i < nextSibling->keyCount; i++) {
        nextSibling->keys[i - 1] = nextSibling->keys[i];
    }

    if (!nextSibling->isLeaf) {
        for (int j = 0; j < nextSibling->keyCount; j++) {
            nextSibling->childs[j] = nextSibling->childs[j + 1];
        }
    }

    // ### 更新
    nextSibling->keyCount--;
    curChild->keyCount++;
}

static void traverseBTree(BTree btree) {
    traverseBTreeNode(btree->root, 0);
    printf("\n");
}

static void traverseBTreeNode(BTreeNode btreeNode, int depth) {
    if (!btreeNode) {
        return;
    }

    if (btreeNode->isLeaf) {
        for (int i = 0; i < btreeNode->keyCount; i++) {
            printf("[%d: %d]\t", depth, btreeNode->keys[i]);
        }
        return;
    }

    // ### nonleaf
    for (int j = 0; j < btreeNode->keyCount; j++) {
        traverseBTreeNode(btreeNode->childs[j], depth + 1);
        printf("<%d: %d>\t", depth, btreeNode->keys[j]);
    }
    traverseBTreeNode(btreeNode->childs[btreeNode->keyCount], depth + 1);
}

static int checkBTree(BTree btree) {
    if (!btree) {
        return 0;
    }

    if (!btree->root) {
        return 0;
    }

    if (btree->root->keyCount < 1) {
        return -1;
    }

    int checkRet;
    if (!btree->root->isLeaf) {
        for (int i = 0; i <= btree->root->keyCount; i++) {
            if (!btree->root->childs[i]) {
                printf("%d\n", i);
                return -2;
            }

            checkRet = checkBTreeNode(btree->root->childs[i]);
            if (checkRet < 0) {
                return -3 + checkRet;
            }
        }
    }

    return 0;
}

// 前提：不检查 root
static int checkBTreeNode(BTreeNode btreeNode) {
    if (!btreeNode) {
        return 0;
    }

    if (btreeNode->keyCount < (btreeNode->t - 1) || btreeNode->keyCount > (2 * btreeNode->t - 1)) {
        return -1;
    }

    if (btreeNode->isLeaf) {
        for (int i = 1; i < btreeNode->keyCount; i++) {
            if (btreeNode->keys[i - 1] > btreeNode->keys[i]) {
                return -2;
            }
        }
    } else {
        int checkRet;
        Position curChild;
        int j;
        for (j = 0; j < btreeNode->keyCount; j++) {
            curChild = btreeNode->childs[j];
            checkRet = checkBTreeNode(curChild);
            if (checkRet < 0) {
                return checkRet;
            }

            if (curChild->keys[curChild->keyCount - 1] > btreeNode->keys[j]) {
                return -3;
            }
        }
        // ### 检查最后一个 child
        curChild = btreeNode->childs[j];
        if (curChild->keys[0] < btreeNode->keys[j - 1]) {
            return -2;
        }
        checkRet = checkBTreeNode(curChild);
        if (checkRet < 0) {
            return checkRet;
        }
    }

    return 0;
}

static void printArray(const int* array, int n) {
    for (int i = 0; i < n; i++) {
        printf("%d\t", array[i]);
    }
    printf("\n");
}

static void genRandomNums(int* outArray, int n, int lower, int upper) {
    srand(time(0));
    int tmpUpper = upper - lower + 1;
    for (int i = 0; i < n; i++) {
        outArray[i] = rand() % tmpUpper + lower;
    }
}

static clock_t getTime() {
    clock_t t = clock();
    if (t == (clock_t)-1) {
        fprintf(stderr, "clock() failed\n");
        exit(EXIT_FAILURE);
    }
    return t;
}

static void testBTree() {
    int array[ARRAY_SIZE];
    genRandomNums(array, ARRAY_SIZE, 100, ARRAY_SIZE + 999);
    /* printArray(array, ARRAY_SIZE); */

    BTree btree = btreeInitialize(2);
    int center = ARRAY_SIZE / 2;
    clock_t start, end, duration;
    start = getTime();
	for (int i = center; i >= 0; i--) {
		btreeInsert(array[i], btree);
	}
    for (int j = center + 1; j < ARRAY_SIZE; j++) {
		btreeInsert(array[j], btree);
    }
    int checkRet = checkBTree(btree);
    if (checkRet < 0) {
        fprintf(stderr, "insert checkRet: %d\n", checkRet);
        exit(EXIT_FAILURE);
    }
    /* traverseBTree(btree); */

    for (int q = 0; q < ARRAY_SIZE; q++) {
        btreeDelete(array[q], btree);
        /* traverseBTree(btree); */
        int checkRet = checkBTree(btree);
        if (checkRet < 0) {
            fprintf(stderr, "delete checkRet: %d\n", checkRet);
            exit(EXIT_FAILURE);
        }
    }
    printf("After Deleting!\n");
    traverseBTree(btree);
    end = getTime();
    // 取上限
    duration = ((end - start) - 1) / CLOCKS_PER_SEC + 1;
    printf("duration = %lfs\n", (double) duration);

    btreeDestroy(btree);
}

int main() {
    testBTree();
    return 0;
}
```

### Huffman Tree（哈夫曼树）

```c
// ### refer:
// https://www.geeksforgeeks.org/huffman-coding-greedy-algo-3/

// ### 说明
// 建立一个堆，其节点是一个一棵树。初始时，用每个数建立一棵树，所以每棵树只有一个节点，然后将每个棵的插入堆中。
// 构造 huffman 树的步骤：
//      在堆中弹出两个最小频率的根节点的树，合并两棵树，并产生一个新的根节点，然后将合并后的树的根节点插入堆中。直到堆中只有一个堆节点。剩下的堆节点就是 huffman tree。

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <limits.h>
#include <time.h>

#define NONLEAF_DATA '$'
#define STR_SIZE 2

struct HuffmanTreeNode;
struct HeapStruct;
typedef struct HuffmanTreeNode* PtrToHuffmanTreeNode;
typedef PtrToHuffmanTreeNode HuffmanTree;
typedef int FreqSize;

// ### BinHeap
#define ARRAY_SIZE (26 + 26)
#define BIN_HEAP_MIN_DATA (INT_MIN)

typedef struct HeapStruct *BinHeap;
typedef HuffmanTree ElementType;
typedef int Position;

struct HuffmanTreeNode {
    char data;
    FreqSize freq;
    PtrToHuffmanTreeNode leftChild, rightChild;
};

struct HeapStruct {
    int capacity;
    int size;
    ElementType* elements;
};

HuffmanTree huffmanTreeBuild(char* datas, FreqSize* freqs, int n);
void huffmanTreeDestroy(HuffmanTree huffmanTree);
static HuffmanTree huffmanTreeMerge(HuffmanTree huffmanTree1, HuffmanTree huffmanTree2);

static bool huffmanTreeIsLeaf(HuffmanTree huffmanTree);
static void printHuffmanTreeCodes(HuffmanTree huffmanTree, int* array, int top);

// ### BinHeap
void binHeapInsert(ElementType element, BinHeap binHeap);
ElementType binHeapDeleteMin(BinHeap binHeap);
BinHeap binHeapInitialize(int capacity);
void binHeapDestroy(BinHeap binHeap);
ElementType binHeapFindMin(BinHeap binHeap);

inline bool binHeapIsEmpty(BinHeap binHeap) {
    return !binHeap->size;
}

inline bool binHeapIsFull(BinHeap binHeap) {
    return binHeap->size + 1 == binHeap->capacity;
}

static void printBinHeap(BinHeap binHeap);

HuffmanTree huffmanTreeBuild(char* datas, FreqSize* freqs, int n) {
    if (n < 0) {
        fprintf(stderr, "n < 0!\n");
        exit(EXIT_FAILURE);
    }

    BinHeap binHeap = binHeapInitialize(n + 1);
    ElementType newNode;
    for (int i = 0; i < n; i++) {
        newNode = malloc(sizeof(struct HuffmanTreeNode));
        if (!newNode) {
            fprintf(stderr, "No space for creating newNode!\n");
            exit(EXIT_FAILURE);
        }
        newNode->data = datas[i];
        newNode->freq = freqs[i];
        newNode->leftChild = newNode->rightChild = NULL;

        binHeapInsert(newNode, binHeap);
    }

    if (n == 1) {
        return binHeapFindMin(binHeap);
    }

    // n > 1
    HuffmanTree newHuffmanTree, huffmanTree1, huffmanTree2;
    for (int j = 0; j < n - 1; j++) {
        huffmanTree1 = binHeapFindMin(binHeap);
        binHeapDeleteMin(binHeap);
        huffmanTree2 = binHeapFindMin(binHeap);
        binHeapDeleteMin(binHeap);

        newHuffmanTree = huffmanTreeMerge(huffmanTree1, huffmanTree2);
        binHeapInsert(newHuffmanTree, binHeap);
    }

    return binHeapFindMin(binHeap);
}

void huffmanTreeDestroy(HuffmanTree huffmanTree) {
    if (!huffmanTree) {
        return;
    }

    huffmanTreeDestroy(huffmanTree->leftChild);
    huffmanTreeDestroy(huffmanTree->rightChild);
    free(huffmanTree);
}

static HuffmanTree huffmanTreeMerge(HuffmanTree huffmanTree1, HuffmanTree huffmanTree2) {
    PtrToHuffmanTreeNode newNode = malloc(sizeof(struct HuffmanTreeNode));
    if (!newNode) {
        fprintf(stderr, "No space for creating newNode!\n");
        exit(EXIT_FAILURE);
    }
    newNode->data = NONLEAF_DATA;
    newNode->freq = huffmanTree1->freq + huffmanTree2->freq;
    newNode->leftChild = huffmanTree1;
    newNode->rightChild = huffmanTree2;

    return newNode;
}

static bool huffmanTreeIsLeaf(HuffmanTree huffmanTree) {
    return !huffmanTree->leftChild && !huffmanTree->rightChild;
}

// prefix 要保证有足够的空间
static void printHuffmanTreeCodes(HuffmanTree huffmanTree, int* prefix, int top) {
    if (!huffmanTree) {
        return;
    }

    if (huffmanTreeIsLeaf(huffmanTree)) {
        printf("%c: ", huffmanTree->data);
        for (int i = 0; i < top; i++) {
            printf("%d", prefix[i]);
        }
        printf("\n");
        return;
    }

    // 向左则为 0
    if (huffmanTree->leftChild) {
        prefix[top] = 0;
        printHuffmanTreeCodes(huffmanTree->leftChild, prefix, top + 1);
    }

    if (huffmanTree->rightChild) {
        prefix[top] = 1;
        printHuffmanTreeCodes(huffmanTree->rightChild, prefix, top + 1);
    }
}

void binHeapInsert(ElementType element, BinHeap binHeap) {
    if (binHeapIsFull(binHeap)) {
        fprintf(stderr, "BinHeap is full!\n");
        exit(EXIT_FAILURE);
    }

    // ### 下移动父节点, 直至有空位，然后插入
    Position curPos = ++binHeap->size;
    Position parent = curPos / 2;
    // element 必须是小于等于 minData 的，否则数组越界。
    while (element->freq < binHeap->elements[parent]->freq) {
        binHeap->elements[curPos] = binHeap->elements[parent];

        curPos = parent;
        parent = curPos / 2;
    }
    binHeap->elements[curPos] = element;
}

ElementType binHeapDeleteMin(BinHeap binHeap) {
    if (binHeapIsEmpty(binHeap)) {
        fprintf(stderr, "BinHeap is empty!\n");
        exit(EXIT_FAILURE);
    }

    // 只用于返回
    ElementType minElement = binHeap->elements[1];

    // 因为删除了堆顶，所以用最后一个节点补上
    ElementType lastElement = binHeap->elements[binHeap->size--];

    // 上移较小的儿子，直至叶子结点
    Position curPos = 1;
    Position child = curPos * 2;
    while (child <= binHeap->size) {
        // 选出较小儿子
        if (child < binHeap->size && binHeap->elements[child]->freq > binHeap->elements[child + 1]->freq) {
            child++;
        }

        if (lastElement->freq > binHeap->elements[child]->freq) {
            // 上移较小的儿子
            binHeap->elements[curPos] = binHeap->elements[child];
        } else {
            break;
        }

        curPos = child;
        child = curPos * 2;
    }
    binHeap->elements[curPos] = lastElement;

    return minElement;
}

BinHeap binHeapInitialize(int capacity) {
    BinHeap binHeap = malloc(sizeof(struct HeapStruct));
    if (!binHeap) {
        fprintf(stderr, "No space for creating binHeap!\n");
        exit(EXIT_FAILURE);
    }

    binHeap->elements = malloc(sizeof(ElementType) * capacity);
    if (!binHeap->elements) {
        fprintf(stderr, "No space for creating binHeap->elements!\n");
        exit(EXIT_FAILURE);
    }

    binHeap->capacity = capacity;
    binHeap->size = 0;

    // ### 设置 elements[0]
    binHeap->elements[0] = malloc(sizeof(struct HuffmanTreeNode));
    // 设置 binHeap 的下界
    binHeap->elements[0]->freq = BIN_HEAP_MIN_DATA;

    return binHeap;
}

void binHeapDestroy(BinHeap binHeap) {
    for (int i = 0; i < binHeap->size; i++) {
        huffmanTreeDestroy(binHeap->elements[i]);
    }
    free(binHeap->elements);
    free(binHeap);
}

ElementType binHeapFindMin(BinHeap binHeap) {
    if (binHeapIsEmpty(binHeap)) {
        fprintf(stderr, "BinHeap is empty!\n");
        exit(EXIT_FAILURE);
    }
    return binHeap->elements[1];
}

void printArray(int* array, int n) {
    for (int i = 0; i < n; i++) {
        printf("%d\t", array[i]);
    }
    printf("\n");
}

void genRandomNums(int* outArray, int n, int lower, int upper) {
    srand(time(0));
    int tmpUpper = upper - lower + 1;
    for (int i = 0; i < n; i++) {
        outArray[i] = rand() % tmpUpper + lower;
    }
}

void genRandomChars(char* outArray, size_t n, char lower, char upper) {
    srand(time(0));
    int tmpUpper = upper - lower + 1;
    int j;
    for (size_t i = 0; i < n; i++) {
        outArray[i] = (char) (rand() % tmpUpper + lower);
    }
}

clock_t getTime() {
    clock_t t = clock();
    if (t == (clock_t)-1) {
        fprintf(stderr, "clock() failed\n");
        exit(EXIT_FAILURE);
    }
    return t;
}

void testHuffmanTree() {
	char datas[ARRAY_SIZE];
    for (int i = 0; i < 26; i++) {
        datas[i] = 'A' + i;
        datas[26 + i] = 'a' + i;
    }
	FreqSize freqs[ARRAY_SIZE];
    genRandomNums(freqs, ARRAY_SIZE, 100, ARRAY_SIZE + 999);

	HuffmanTree huffmanTree = huffmanTreeBuild(datas, freqs, ARRAY_SIZE);
    int prefix[ARRAY_SIZE];
    printHuffmanTreeCodes(huffmanTree, prefix, 0);
}

int main() {
    testHuffmanTree();
	return 0;
}

```

## Heap
### Binary Heap（二叉堆）

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <limits.h>
#include <stdbool.h>

#define ARRAY_SIZE (10000 * 10)
#define MIN_DATA (INT_MIN)

typedef int ElementType;
struct HeapStruct;
typedef struct HeapStruct *BinHeap;
typedef int Position;

struct HeapStruct {
	int capacity;
	int size;
	ElementType *elements;
};

void binHeapInsert(ElementType element, BinHeap binHeap);
ElementType binHeapDeleteMin(BinHeap binHeap);
BinHeap binHeapInitialize(int capacity);
void binHeapDestroy(BinHeap binHeap);
void binHeapMakeEmpty(BinHeap binHeap);
ElementType binHeapFindMin(BinHeap binHeap);

inline bool binHeapIsEmpty(BinHeap binHeap) {
    return !binHeap->size;
}

inline bool binHeapIsFull(BinHeap binHeap) {
    return binHeap->size + 1 == binHeap->capacity;
}

static void printBinHeap(BinHeap binHeap);
static int checkBinHeap(BinHeap binHeap);

void binHeapInsert(ElementType element, BinHeap binHeap) {
    if (binHeapIsFull(binHeap)) {
        fprintf(stderr, "BinHeap is full!\n");
        exit(EXIT_FAILURE);
    }

    // ### 下移动父节点, 直至有空位，然后插入
    Position curPos = ++binHeap->size;
    Position parent = curPos / 2;
    // element 必须是小于等于 minData 的，否则数组越界。
    while (element < binHeap->elements[parent]) {
        binHeap->elements[curPos] = binHeap->elements[parent];

        curPos = parent;
        parent = curPos / 2;
    }
    binHeap->elements[curPos] = element;
}

ElementType binHeapDeleteMin(BinHeap binHeap) {
    if (binHeapIsEmpty(binHeap)) {
        fprintf(stderr, "BinHeap is empty!\n");
        exit(EXIT_FAILURE);
    }

    // 只用于返回
    ElementType minElement = binHeap->elements[1];

    // 因为删除了堆顶，所以用最后一个节点补上
    ElementType lastElement = binHeap->elements[binHeap->size--];

    // 上移较小的儿子，直至叶子结点
    Position curPos = 1;
    Position child = curPos * 2;
    while (child <= binHeap->size) {
        // 选出较小儿子
        if (child < binHeap->size && binHeap->elements[child] > binHeap->elements[child + 1]) {
            child++;
        }

        if (lastElement > binHeap->elements[child]) {
            // 上移较小的儿子
            binHeap->elements[curPos] = binHeap->elements[child];
        } else {
            break;
        }

        curPos = child;
        child = curPos * 2;
    }
    binHeap->elements[curPos] = lastElement;

    return minElement;
}

BinHeap binHeapInitialize(int capacity) {
    BinHeap binHeap = malloc(sizeof(struct HeapStruct));
    if (!binHeap) {
        fprintf(stderr, "No space for creating binHeap!\n");
        exit(EXIT_FAILURE);
    }

    binHeap->elements = malloc(sizeof(ElementType) * capacity);
    if (!binHeap->elements) {
        fprintf(stderr, "No space for creating binHeap->elements!\n");
        exit(EXIT_FAILURE);
    }

    binHeap->capacity = capacity;
    binHeap->size = 0;

    // 设置 binHeap 的下界
    binHeap->elements[0] = MIN_DATA;

    return binHeap;
}

void binHeapDestroy(BinHeap binHeap) {
    free(binHeap->elements);
    free(binHeap);
}

void binHeapMakeEmpty(BinHeap binHeap) {
    binHeap->size = 0;
}

ElementType binHeapFindMin(BinHeap binHeap) {
    if (binHeapIsEmpty(binHeap)) {
        fprintf(stderr, "BinHeap is empty!\n");
        exit(EXIT_FAILURE);
    }
    return binHeap->elements[1];
}

static void printBinHeap(BinHeap binHeap) {
    for (int i = 1; i < binHeap->size; i++) {
        printf("%d\t", binHeap->elements[i]);
    }
    printf("\n");
}

static int checkBinHeap(BinHeap binHeap) {
    if (binHeapIsEmpty(binHeap)) {
        return 0;
    }

    int curPos = 1;
    int leftChild = curPos * 2, rightChild, minChild;
    while (leftChild <= binHeap->size) {
        rightChild = leftChild + 1;
        minChild = leftChild;
        if (rightChild <= binHeap->size && binHeap->elements[leftChild] > binHeap->elements[rightChild]) {
            minChild = rightChild;
        }

        // 父结点可以等于 minChild 结点
        if (binHeap->elements[curPos] > binHeap->elements[minChild]) {
            return -1;
        }
        curPos++;
        leftChild = curPos * 2;
    }

    return 0;
}

void printArray(int* array, int n) {
    for (int i = 0; i < n; i++) {
        printf("%d\t", array[i]);
    }
    printf("\n");
}

void genRandomNums(int* outArray, int n, int lower, int upper) {
    srand(time(0));
    int tmpUpper = upper - lower + 1;
    for (int i = 0; i < n; i++) {
        outArray[i] = rand() % tmpUpper + lower;
    }
}

clock_t getTime() {
    clock_t t = clock();
    if (t == (clock_t)-1) {
        fprintf(stderr, "clock() failed\n");
        exit(EXIT_FAILURE);
    }
    return t;
}

void testBinHeap() {
    int array[ARRAY_SIZE];
    genRandomNums(array, ARRAY_SIZE, 100, ARRAY_SIZE + 999);
    /* printArray(array, ARRAY_SIZE); */

	BinHeap binHeap = binHeapInitialize(ARRAY_SIZE + 1);
    int center = ARRAY_SIZE / 2;
    clock_t start, end, duration;
    start = getTime();
	for (int i = center; i >= 0; i--) {
		binHeapInsert(array[i], binHeap);
	}
    for (int j = center + 1; j < ARRAY_SIZE; j++) {
		binHeapInsert(array[j], binHeap);
    }
    /* int checkRet = checkBinHeap(binHeap); */
    /* if (checkRet < 0) { */
    /*     fprintf(stderr, "checkRet: %d\n", checkRet); */
    /*     exit(EXIT_FAILURE); */
    /* } */
    /* printBinHeap(binHeap); */

    for (int q = 0; q < ARRAY_SIZE; q++) {
        binHeapDeleteMin(binHeap);
        /* checkRet = checkBinHeap(binHeap); */
        /* if (checkRet < 0) { */
        /*     fprintf(stderr, "checkRet: %d\n", checkRet); */
        /*     exit(EXIT_FAILURE); */
        /* } */
    }
    printBinHeap(binHeap);
    end = getTime();
    // 取上限
    duration = ((end - start) - 1) / CLOCKS_PER_SEC + 1;
    printf("duration = %lfs\n", (double) duration);

    binHeapDestroy(binHeap);
}

int main() {
	testBinHeap();
	return 0;
}
```

### Leftist Heap（左式堆）

```c
// ### 说明
// 左式堆：对于堆中的每一个节点，其左儿子的零路径长至少与右儿子的零路径长一样大。具有堆的性质。
// 零路径长：具有 2 个儿子，Npl(2) = 1; 0 个或 1 个儿子的节点的 Npl(0 | 1) = 0; Npl(NULL) = -1 。 leftistHeap->Npl = leftistHeap->Right->Npl + 1 。
// 两个左式堆合并的操作：堆顶最小的堆的右子树与另一个堆合并。
// 插入：即两个堆合并
// 删除Min：即一个堆的左右子树合并

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <time.h>

#define ARRAY_SIZE (1000 * 10)

typedef int ElementType;

struct TreeNode;
typedef struct TreeNode* PtrToNode;
typedef PtrToNode LeftistHeap;
typedef PtrToNode Position;

struct TreeNode {
    ElementType element;
    PtrToNode leftChild;
    PtrToNode rightChild;
    int npl;
};

LeftistHeap leftistHeapInsert(ElementType element, LeftistHeap leftistHeap);
LeftistHeap leftistHeapDeleteMin(LeftistHeap leftistHeap);
LeftistHeap leftistHeapInitialize();
void leftistHeapDestroy(LeftistHeap leftistHeap);

inline ElementType leftistHeapFindMin(LeftistHeap leftistHeap) {
    return leftistHeap->element;
}

inline bool leftistHeapIsEmpty(LeftistHeap leftistHeap) {
    return !leftistHeap ? true : false;
}

static LeftistHeap leftistHeapMerge(LeftistHeap leftistHeap1, LeftistHeap leftistHeap2);
static LeftistHeap leftistHeapMerge1(LeftistHeap leftistHeap1, LeftistHeap leftistHeap2);
static void leftistHeapSwapChildren(LeftistHeap leftistHeap);
static int checkLeftistHeap(LeftistHeap leftistHeap);
static void printLeftistHeap(LeftistHeap leftistHeap);

LeftistHeap leftistHeapInsert(ElementType element, LeftistHeap leftistHeap) {
    PtrToNode newNode = malloc(sizeof(struct TreeNode));
    if (!newNode) {
        fprintf(stderr, "No space for creating newNode!\n");
        exit(EXIT_FAILURE);
    }
    newNode->element = element;
    newNode->leftChild = newNode->rightChild = NULL;
    newNode->npl = 0;

    return leftistHeap = leftistHeapMerge(newNode, leftistHeap);
}

LeftistHeap leftistHeapDeleteMin(LeftistHeap leftistHeap) {
    if (leftistHeapIsEmpty(leftistHeap)) {
        fprintf(stderr, "leftistHeap is empty!\n");
        exit(EXIT_FAILURE);
    }

    Position tmpNode = leftistHeap;
    leftistHeap = leftistHeapMerge(leftistHeap->leftChild, leftistHeap->rightChild);
    free(tmpNode);
    return leftistHeap;
}

LeftistHeap leftistHeapInitialize() {
    return NULL;
}

void leftistHeapDestroy(LeftistHeap leftistHeap) {
    if (!leftistHeap) {
        return;
    }

    leftistHeapDestroy(leftistHeap->leftChild);
    leftistHeapDestroy(leftistHeap->rightChild);
    free(leftistHeap);
}

static LeftistHeap leftistHeapMerge(LeftistHeap leftistHeap1, LeftistHeap leftistHeap2) {
    if (!leftistHeap1) {
        return leftistHeap2;
    }

    if (!leftistHeap2) {
        return leftistHeap1;
    }

    if (leftistHeap1->element < leftistHeap2->element) {
        return leftistHeapMerge1(leftistHeap1, leftistHeap2);
    } else {
        return leftistHeapMerge1(leftistHeap2, leftistHeap1);
    }
}

// leftistHeap1->element < leftistHeap2->element
// leftistHeap1, leftistHeap2 不为空。
static LeftistHeap leftistHeapMerge1(LeftistHeap leftistHeap1, LeftistHeap leftistHeap2) {
    if (!leftistHeap1->leftChild) {
        leftistHeap1->leftChild = leftistHeap2;
    } else {
        leftistHeap1->rightChild = leftistHeapMerge(leftistHeap1->rightChild, leftistHeap2);
        if (leftistHeap1->leftChild->npl < leftistHeap1->rightChild->npl) {
            leftistHeapSwapChildren(leftistHeap1);
        }

        leftistHeap1->npl = leftistHeap1->rightChild->npl + 1;
    }

    return leftistHeap1;
}

// leftistHeap 不为空
static void leftistHeapSwapChildren(LeftistHeap leftistHeap) {
    Position tmpPos = leftistHeap->leftChild;
    leftistHeap->leftChild = leftistHeap->rightChild;
    leftistHeap->rightChild = tmpPos;
}

static void printLeftistHeap1(LeftistHeap leftistHeap) {
    if (!leftistHeap) {
        return;
    }

    printf("%d\t", leftistHeap->element);
    printLeftistHeap1(leftistHeap->leftChild);
    printLeftistHeap1(leftistHeap->rightChild);
}

static void printLeftistHeap(LeftistHeap leftistHeap) {
    printLeftistHeap1(leftistHeap);
    printf("\n");
}

static int checkLeftistHeap(LeftistHeap leftistHeap) {
    if (!leftistHeap) {
        return 0;
    }

    bool isHeapInOrder = true;
    int leftChildNpl;
    if (!leftistHeap->leftChild) {
        leftChildNpl = -1;
    } else {
        leftChildNpl = leftistHeap->leftChild->npl;
        if (leftistHeap->element > leftistHeap->leftChild->element) {
            isHeapInOrder = false;
        }
    }

    int rightChildNpl;
    if (!leftistHeap->rightChild) {
        rightChildNpl = -1;
    } else {
        rightChildNpl = leftistHeap->rightChild->npl;
        if (leftistHeap->element > leftistHeap->rightChild->element) {
            isHeapInOrder = false;
        }
    }

    if (leftChildNpl < rightChildNpl) {
        return -1;
    }

    if (leftistHeap->npl != rightChildNpl + 1) {
        return -2;
    }

    if (!isHeapInOrder) {
        return -3;
    }

    int checkRet = checkLeftistHeap(leftistHeap->leftChild);
    if (checkRet < 0) {
        return checkRet;
    }

    checkRet = checkLeftistHeap(leftistHeap->rightChild);
    if (checkRet < 0) {
        return checkRet;
    }

    return 0;
}

void printArray(const int* array, int n) {
    for (int i = 0; i < n; i++) {
        printf("%d\t", array[i]);
    }
    printf("\n");
}

void genRandomNums(int* outArray, int n, int lower, int upper) {
    srand(time(0));
    int tmpUpper = upper - lower + 1;
    for (int i = 0; i < n; i++) {
        outArray[i] = rand() % tmpUpper + lower;
    }
}

clock_t getTime() {
    clock_t t = clock();
    if (t == (clock_t)-1) {
        fprintf(stderr, "clock() failed\n");
        exit(EXIT_FAILURE);
    }
    return t;
}

static void testLeftistHeap() {
    int array[ARRAY_SIZE];
    genRandomNums(array, ARRAY_SIZE, 100, ARRAY_SIZE + 999);
    /* printArray(array, ARRAY_SIZE); */

    LeftistHeap leftistHeap = leftistHeapInitialize();
    int center = ARRAY_SIZE / 2;
    clock_t start, end, duration;
    start = getTime();
	for (int i = center; i >= 0; i--) {
        leftistHeap = leftistHeapInsert(array[i], leftistHeap);
	}
    for (int j = center + 1; j < ARRAY_SIZE; j++) {
        leftistHeap = leftistHeapInsert(array[j], leftistHeap);
    }
    /* int checkRet = checkLeftistHeap(leftistHeap); */
    /* if (checkRet < 0) { */
    /*     fprintf(stderr, "checkRet: %d\n", checkRet); */
    /*     exit(EXIT_FAILURE); */
    /* } */
    /* printLeftistHeap(leftistHeap); */

    for (int q = 0; q < ARRAY_SIZE; q++) {
        leftistHeap = leftistHeapDeleteMin(leftistHeap);
        if (!leftistHeap) {
            break;
        }
        /* checkRet = checkLeftistHeap(leftistHeap); */
        /* if (checkRet < 0) { */
        /*     fprintf(stderr, "checkRet: %d\n", checkRet); */
        /*     exit(EXIT_FAILURE); */
        /* } */
    }
    printLeftistHeap(leftistHeap);
    end = getTime();
    // 取上限
    duration = ((end - start) - 1) / CLOCKS_PER_SEC + 1;
    printf("duration = %lfs\n", (double) duration);

    leftistHeapDestroy(leftistHeap);
}

int main() {
    testLeftistHeap();
    return 0;
}
```

### Skew Heap（斜堆）

对左式堆的改进，没有零和路径长的信息，合并之后每个有右儿子的结点的交换是无条件的。如果没有右儿子则不交换，因为交换没有意义。

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <time.h>

#define ARRAY_SIZE (1000 * 10)

typedef int ElementType;

struct TreeNode;
typedef struct TreeNode* PtrToNode;
typedef PtrToNode SkewHeap;
typedef PtrToNode Position;

struct TreeNode {
    ElementType element;
    PtrToNode leftChild;
    PtrToNode rightChild;
};

SkewHeap skewHeapInsert(ElementType element, SkewHeap skewHeap);
SkewHeap skewHeapDeleteMin(SkewHeap skewHeap);
SkewHeap skewHeapInitialize();
void skewHeapDestroy(SkewHeap skewHeap);

inline ElementType skewHeapFindMin(SkewHeap skewHeap) {
    return skewHeap->element;
}

inline bool skewHeapIsEmpty(SkewHeap skewHeap) {
    return !skewHeap ? true : false;
}

static SkewHeap skewHeapMerge(SkewHeap skewHeap1, SkewHeap skewHeap2);
static SkewHeap skewHeapMerge1(SkewHeap skewHeap1, SkewHeap skewHeap2);
static void skewHeapSwapChildren(SkewHeap skewHeap);
static int checkSkewHeap(SkewHeap skewHeap);
static void printSkewHeap(SkewHeap skewHeap);

SkewHeap skewHeapInsert(ElementType element, SkewHeap skewHeap) {
    PtrToNode newNode = malloc(sizeof(struct TreeNode));
    if (!newNode) {
        fprintf(stderr, "No space for creating newNode!\n");
        exit(EXIT_FAILURE);
    }
    newNode->element = element;
    newNode->leftChild = newNode->rightChild = NULL;

    return skewHeap = skewHeapMerge(newNode, skewHeap);
}

SkewHeap skewHeapDeleteMin(SkewHeap skewHeap) {
    if (skewHeapIsEmpty(skewHeap)) {
        fprintf(stderr, "skewHeap is empty!\n");
        exit(EXIT_FAILURE);
    }

    Position tmpNode = skewHeap;
    skewHeap = skewHeapMerge(skewHeap->leftChild, skewHeap->rightChild);
    free(tmpNode);
    return skewHeap;
}

SkewHeap skewHeapInitialize() {
    return NULL;
}

void skewHeapDestroy(SkewHeap skewHeap) {
    if (!skewHeap) {
        return;
    }

    skewHeapDestroy(skewHeap->leftChild);
    skewHeapDestroy(skewHeap->rightChild);
    free(skewHeap);
}

static SkewHeap skewHeapMerge(SkewHeap skewHeap1, SkewHeap skewHeap2) {
    if (!skewHeap1) {
        return skewHeap2;
    }

    if (!skewHeap2) {
        return skewHeap1;
    }

    if (skewHeap1->element < skewHeap2->element) {
        return skewHeapMerge1(skewHeap1, skewHeap2);
    } else {
        return skewHeapMerge1(skewHeap2, skewHeap1);
    }
}

// skewHeap1->element < skewHeap2->element
// skewHeap1, skewHeap2 不为空。
static SkewHeap skewHeapMerge1(SkewHeap skewHeap1, SkewHeap skewHeap2) {
    skewHeap1->rightChild = skewHeapMerge(skewHeap1->rightChild, skewHeap2);
    // 合并之后旋转
    skewHeapSwapChildren(skewHeap1);

    return skewHeap1;
}

// skewHeap 不为空
static void skewHeapSwapChildren(SkewHeap skewHeap) {
    Position tmpPos = skewHeap->leftChild;
    skewHeap->leftChild = skewHeap->rightChild;
    skewHeap->rightChild = tmpPos;
}

static void printSkewHeap1(SkewHeap skewHeap) {
    if (!skewHeap) {
        return;
    }

    printf("%d\t", skewHeap->element);
    printSkewHeap1(skewHeap->leftChild);
    printSkewHeap1(skewHeap->rightChild);
}

static void printSkewHeap(SkewHeap skewHeap) {
    printSkewHeap1(skewHeap);
    printf("\n");
}

static int checkSkewHeap(SkewHeap skewHeap) {
    if (!skewHeap) {
        return 0;
    }

    bool isHeapInOrder = true;
    if (skewHeap->leftChild && skewHeap->element > skewHeap->leftChild->element) {
        isHeapInOrder = false;
    }

    if (skewHeap->rightChild && skewHeap->element > skewHeap->rightChild->element) {
        isHeapInOrder = false;
    }

    if (!isHeapInOrder) {
        return -1;
    }

    int checkRet = checkSkewHeap(skewHeap->leftChild);
    if (checkRet < 0) {
        return checkRet;
    }

    checkRet = checkSkewHeap(skewHeap->rightChild);
    if (checkRet < 0) {
        return checkRet;
    }

    return 0;
}

void printArray(const int* array, int n) {
    for (int i = 0; i < n; i++) {
        printf("%d\t", array[i]);
    }
    printf("\n");
}

void genRandomNums(int* outArray, int n, int lower, int upper) {
    srand(time(0));
    int tmpUpper = upper - lower + 1;
    for (int i = 0; i < n; i++) {
        outArray[i] = rand() % tmpUpper + lower;
    }
}

clock_t getTime() {
    clock_t t = clock();
    if (t == (clock_t)-1) {
        fprintf(stderr, "clock() failed\n");
        exit(EXIT_FAILURE);
    }
    return t;
}

static void testSkewHeap() {
    int array[ARRAY_SIZE];
    genRandomNums(array, ARRAY_SIZE, 100, ARRAY_SIZE + 999);
    /* printArray(array, ARRAY_SIZE); */

    SkewHeap skewHeap = skewHeapInitialize();
    int center = ARRAY_SIZE / 2;
    clock_t start, end, duration;
    start = getTime();
	for (int i = center; i >= 0; i--) {
        skewHeap = skewHeapInsert(array[i], skewHeap);
	}
    for (int j = center + 1; j < ARRAY_SIZE; j++) {
        skewHeap = skewHeapInsert(array[j], skewHeap);
    }
    /* int checkRet = checkSkewHeap(skewHeap); */
    /* if (checkRet < 0) { */
    /*     fprintf(stderr, "checkRet: %d\n", checkRet); */
    /*     exit(EXIT_FAILURE); */
    /* } */
    /* printSkewHeap(skewHeap); */

    for (int q = 0; q < ARRAY_SIZE; q++) {
        skewHeap = skewHeapDeleteMin(skewHeap);
        if (!skewHeap) {
            break;
        }
        /* checkRet = checkSkewHeap(skewHeap); */
        /* if (checkRet < 0) { */
        /*     fprintf(stderr, "checkRet: %d\n", checkRet); */
        /*     exit(EXIT_FAILURE); */
        /* } */
    }
    printSkewHeap(skewHeap);
    end = getTime();
    // 取上限
    duration = ((end - start) - 1) / CLOCKS_PER_SEC + 1;
    printf("duration = %lfs\n", (double) duration);

    skewHeapDestroy(skewHeap);
}

int main() {
    testSkewHeap();
    return 0;
}
```

### Binomial Queue（二项队列）

```c
// ### 说明
// 二项队列由多个二项树组成
// 二项树的上一层小于等于下一层。即父节点小于等于其所有后裔。二项树的节点数：B0 = 1， B1 = 2, B3 = 4, ... , Bn = 2 * Bn-1 。
// 插入和删除都用合并实现

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <limits.h>
#include <time.h>

#define ARRAY_SIZE (1000 * 10)
#define MAX_ELEMENT INT_MAX

typedef int ElementType;

struct BinomialTreeNode;
struct BinomialQueue;
typedef struct BinomialTreeNode* PtrToBinTreeNode;
typedef PtrToBinTreeNode BinTree;
typedef PtrToBinTreeNode Position;
typedef struct BinomialQueue* BinQueue;

struct BinomialTreeNode {
    ElementType element;
    PtrToBinTreeNode leftChild;
    PtrToBinTreeNode nextSibling;
};

struct BinomialQueue {
    int capacity;
    int size;
    BinTree* theTrees;
};

BinQueue binQueueMerge(BinQueue binQueue1, BinQueue binQueue2);
BinQueue binQueueInsert(ElementType element, BinQueue binQueue);
ElementType binQueueDeleteMin(BinQueue binQueue);
BinQueue binQueueInitialize(int capacity);
void binQueueDestroy(BinQueue binQueue);
void binQueueRecapacity(int capacity, BinQueue binQueue);
static int binQueueCalTreeCount(int capacity);
static int binQueueCalCapacity(int treeCount);

static BinTree binTreeCombine(BinTree binTree1, BinTree binTree2);
static void binTreeDestroy(BinTree binTree);
static int binTreeSize();

static void printBinQueue(BinQueue binQueue);
static void printBinTree(BinTree binTree);
static int checkBinQueue(BinQueue binQueue);
static int checkBinTree(BinTree binTree);

// 合并之后，为了 destroy, 会将 binQueue2 的所有二项树置为空。
BinQueue binQueueMerge(BinQueue binQueue1, BinQueue binQueue2) {
    int newSize = binQueue1->size + binQueue2->size;
    if (newSize > binQueue1->capacity) {
        binQueueRecapacity(newSize, binQueue1);
    }
    if (newSize > binQueue2->capacity) {
        binQueueRecapacity(newSize, binQueue2);
    }

    binQueue1->size = newSize;
    BinTree binTreeCarry = NULL, tmpBinTree;
    for (int i = 0, j = 1; j <= binQueue1->size; i++, j *= 2) {
        switch ((!!binQueue1->theTrees[i]) + (!!binQueue2->theTrees[i] << 1) + (!!binTreeCarry << 2)) {
            case 0:
            case 1:
                break;
            case 2:
                binQueue1->theTrees[i] = binQueue2->theTrees[i];
                binQueue2->theTrees[i] = NULL;
                break;
            case 3:
                binTreeCarry = binTreeCombine(binQueue1->theTrees[i], binQueue2->theTrees[i]);
                binQueue1->theTrees[i] = binQueue2->theTrees[i] = NULL;
                break;
            case 4:
                binQueue1->theTrees[i] = binTreeCarry;
                binTreeCarry = NULL;
                break;
            case 5:
                binTreeCarry = binTreeCombine(binQueue1->theTrees[i], binTreeCarry);
                binQueue1->theTrees[i] = NULL;
                break;
            case 6:
                binTreeCarry = binTreeCombine(binQueue2->theTrees[i], binTreeCarry);
                binQueue2->theTrees[i] = NULL;
                break;
            case 7:
                tmpBinTree = binTreeCarry;
                binTreeCarry = binTreeCombine(binQueue1->theTrees[i], binQueue2->theTrees[i]);
                binQueue1->theTrees[i] = tmpBinTree;
                binQueue2->theTrees[i] = NULL;
                break;
        }
    }

    return binQueue1;
}

BinQueue binQueueInsert(ElementType element, BinQueue binQueue) {
    // ### 创建 newBinQueue
    BinQueue newBinQueue = binQueueInitialize(1);
    // #### 创建 newBinTree
    BinTree newBinTree = malloc(sizeof(struct BinomialTreeNode));
    if (!newBinTree) {
        fprintf(stderr, "No space for creating newBinTree!\n");
        exit(EXIT_FAILURE);
    }
    newBinTree->element = element;
    newBinTree->leftChild = newBinTree->nextSibling = NULL;

    // #### 将 newBinTree 加入 newBinQueue
    newBinQueue->theTrees[0] = newBinTree;
    newBinQueue->size++;

    // ### 合并
    binQueue = binQueueMerge(binQueue, newBinQueue);
    binQueueDestroy(newBinQueue);

    return binQueue;
}

ElementType binQueueDeleteMin(BinQueue binQueue) {
    if (!binQueue->size) {
        fprintf(stderr, "binQueue->size == 0!\n");
        exit(EXIT_FAILURE);
    }

    // ### 找出最小的二项树
    ElementType minElement = MAX_ELEMENT;
    int indexOfMinBinTree = 0;
    int treeCount = binQueueCalTreeCount(binQueue->capacity);
    // binQueue->size > 0
    for (int i = 0; i < treeCount; i++) {
        if (binQueue->theTrees[i] && binQueue->theTrees[i]->element < minElement) {
            minElement = binQueue->theTrees[i]->element;
            indexOfMinBinTree = i;
        }
    }

    // ### 删除最小的结点
    Position oldRoot = binQueue->theTrees[indexOfMinBinTree];
    BinTree deletedBinTree = oldRoot->leftChild;
    free(oldRoot);

    // ### 将剩余的结点放入一个 binQueue 中
    int deletedBinQueueSize = (1 << indexOfMinBinTree) - 1;
    BinQueue deletedBinQueue = binQueueInitialize(deletedBinQueueSize);
    // indexOfMinBinTree = 0 时，size = 0;
    deletedBinQueue->size = deletedBinQueueSize;
    for (int j = indexOfMinBinTree - 1; j >= 0; j--) {
        deletedBinQueue->theTrees[j] = deletedBinTree;
        deletedBinTree = deletedBinTree->nextSibling;
        deletedBinQueue->theTrees[j]->nextSibling = NULL;
    }

    // ### 更新 binQueue
    binQueue->theTrees[indexOfMinBinTree] = NULL;
    binQueue->size -= deletedBinQueue->size + 1;

    // ### 合并
    binQueue = binQueueMerge(binQueue, deletedBinQueue);
    binQueueDestroy(deletedBinQueue);

    return minElement;
}

BinQueue binQueueInitialize(int capacity) {
    int treeCount = binQueueCalTreeCount(capacity);
    capacity = binQueueCalCapacity(treeCount);

    // ### 创建 binQueue
    BinQueue binQueue = malloc(sizeof(struct BinomialQueue));
    if (!binQueue) {
        fprintf(stderr, "No space for creating binQueue!\n");
        exit(EXIT_FAILURE);
    }
    binQueue->theTrees = malloc(sizeof(BinTree) * treeCount);
    if (!binQueue->theTrees) {
        fprintf(stderr, "No space for creating theTrees!\n");
        exit(EXIT_FAILURE);
    }
    for (int i = 0; i < treeCount; i++) {
        binQueue->theTrees[i] = NULL;
    }
    binQueue->capacity = capacity;
    binQueue->size = 0;

    return binQueue;
}

void binQueueDestroy(BinQueue binQueue) {
    int treeCount = 0;
    int tmp = binQueue->capacity + 1;
    while (tmp >>= 1) {
        treeCount++;
    }

    for (int i = 0; i < treeCount; i++) {
        binTreeDestroy(binQueue->theTrees[i]);
    }
    free(binQueue->theTrees);
    free(binQueue);
}

void binQueueRecapacity(int capacity, BinQueue binQueue) {
    int oldTreeCount = binQueueCalTreeCount(binQueue->capacity);
    int newTreeCount = binQueueCalTreeCount(capacity);
    int newCapacity = binQueueCalCapacity(newTreeCount);

    BinTree* newBinTrees = malloc(sizeof(BinTree) * newTreeCount);
    if (!newBinTrees) {
        fprintf(stderr, "No space for creating newBinTree!\n");
        exit(EXIT_FAILURE);
    }
    for (int i = 0; i < oldTreeCount; i++) {
        newBinTrees[i] = binQueue->theTrees[i];
    }
    for (int j = oldTreeCount; j < newTreeCount; j++) {
        newBinTrees[j] = NULL;
    }
    free(binQueue->theTrees);
    binQueue->theTrees = newBinTrees;
    binQueue->capacity = newCapacity;
}

static int binQueueCalTreeCount(int capacity) {
    // ### 计算 treeCount
    // pow(2, k + 1) < capacity + 1
    // tmp = pow(2, k + 1)
    // treeCount = k + 1
    int treeCount = 0;
    int tmp = 1;
    while (tmp < capacity + 1) {
        tmp <<= 1;
        treeCount++;
    }
    return treeCount;
}

static int binQueueCalCapacity(int treeCount) {
    return (1 << treeCount) - 1;
}


static BinTree binTreeCombine(BinTree binTree1, BinTree binTree2) {
    if (binTree1->element > binTree2->element) {
        return binTreeCombine(binTree2, binTree1);
    }

    // binTree1->element <= binTree2->element
    binTree2->nextSibling = binTree1->leftChild;
    binTree1->leftChild = binTree2;

    return binTree1;
}

static void binTreeDestroy(BinTree binTree) {
    if (!binTree) {
        return;
    }

    // 销毁所有儿子
    Position tmpPos = binTree->leftChild;
    while (tmpPos) {
        binTreeDestroy(tmpPos);
        tmpPos = tmpPos->nextSibling;
    }

    free(binTree);
}

static void printBinQueue(BinQueue binQueue) {
    if (!binQueue) {
        return;
    }

    int treeCount = binQueueCalTreeCount(binQueue->capacity);
    for (int i = 0; i < treeCount; i++) {
        printf("%d: ", i);
        printBinTree(binQueue->theTrees[i]);
    }
}

static void printBinTree1(BinTree binTree) {
    if (!binTree) {
        return;
    }

    printf("%d\t", binTree->element);

    // 打印所有儿子
    Position tmpPos = binTree->leftChild;
    while (tmpPos) {
        printBinTree1(tmpPos);
        tmpPos = tmpPos->nextSibling;
    }
}

static void printBinTree(BinTree binTree) {
    printBinTree1(binTree);
    printf("\n");
}

static int checkBinQueue(BinQueue binQueue) {
    if (!binQueue) {
        return 0;
    }

    int checkRet;
    int sizeCount = 0;
    int size;
    int treeCount = binQueueCalTreeCount(binQueue->capacity);
    for (int i = 0; i < treeCount; i++) {
        if (!binQueue->theTrees[i]) {
            continue;
        }

        size = binTreeSize(binQueue->theTrees[i]);
        sizeCount += size;
        if ((1 << i) != size) {
            return -1;
        }

        checkRet = checkBinTree(binQueue->theTrees[i]);
        if (checkRet < 0) {
            fprintf(stderr, "in checkBinQueue. checkRet: %d\n", checkRet);
            return -2;
        }
    }

    if (binQueue->size != sizeCount) {
        return -3;
    }

    return 0;
}

static int checkBinTree(BinTree binTree) {
    if (!binTree) {
        return 0;
    }

    int lastSize = binTreeSize(binTree);
    int size;
    int checkRet;
    Position curPos = binTree->leftChild;
    while (curPos) {
        // ### 父结点是否是最小的
        if (curPos->element < binTree->element) {
            return -1;
        }

        // ### 每个儿子的 size 是否是 pow(2, k)
        size = binTreeSize(curPos);
        if (size * 2 != lastSize) {
            return -2;
        }
        lastSize = size;

        // ### 儿子是否是二项树
        checkRet = checkBinTree(curPos);
        if (checkRet < 0) {
            return checkRet;
        }

        curPos = curPos->nextSibling;
    }

    return 0;
}

static int binTreeSize(BinTree binTree) {
    if (!binTree) {
        return 0;
    }

    Position curPos = binTree->leftChild;
    int size = 0;
    while (curPos) {
        size += binTreeSize(curPos);
        curPos = curPos->nextSibling;
    }
    size++;

    return size;
}

void printArray(int* array, int n) {
    for (int i = 0; i < n; i++) {
        printf("%d\t", array[i]);
    }
    printf("\n");
}

void genRandomNums(int* outArray, int n, int lower, int upper) {
    srand(time(0));
    int tmpUpper = upper - lower + 1;
    for (int i = 0; i < n; i++) {
        outArray[i] = rand() % tmpUpper + lower;
    }
}

clock_t getTime() {
    clock_t t = clock();
    if (t == (clock_t)-1) {
        fprintf(stderr, "clock() failed\n");
        exit(EXIT_FAILURE);
    }
    return t;
}

static void testBinQueue() {
    int array[ARRAY_SIZE];
    genRandomNums(array, ARRAY_SIZE, 100, ARRAY_SIZE + 999);
    /* printArray(array, ARRAY_SIZE); */

    BinQueue binQueue = binQueueInitialize(1);
    int center = ARRAY_SIZE / 2;
    clock_t start, end, duration;
    start = getTime();
	for (int i = center; i >= 0; i--) {
		binQueue = binQueueInsert(array[i], binQueue);
	}
    for (int j = center + 1; j < ARRAY_SIZE; j++) {
		binQueue = binQueueInsert(array[j], binQueue);
    }
    /* int checkRet = checkBinQueue(binQueue); */
    /* if (checkRet < 0) { */
    /*     fprintf(stderr, "checkRet: %d\n", checkRet); */
    /*     exit(EXIT_FAILURE); */
    /* } */
    /* printBinQueue(binQueue); */

    for (int q = 0; q < ARRAY_SIZE; q++) {
        if (!binQueue->size) {
            break;
        }
        binQueueDeleteMin(binQueue);
        /* checkRet = checkBinQueue(binQueue); */
        /* if (checkRet < 0) { */
        /*     fprintf(stderr, "checkRet: %d\n", checkRet); */
        /*     exit(EXIT_FAILURE); */
        /* } */
    }
    /* printBinQueue(binQueue); */
    end = getTime();
    // 取上限
    duration = ((end - start) - 1) / CLOCKS_PER_SEC + 1;
    printf("duration = %lfs\n", (double) duration);

    binQueueDestroy(binQueue);
}

int main() {
    testBinQueue();
	return 0;
}
```

## Hash Table
### SeparateChaining

解决冲突的方法是分离链接法，是将散列到同一值的所有元素保留到一个链表中。

```c
// ### 说明
// 链表保留头节点

#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

// log 10000 * 10 / log 26 = 3.5
#define KEY_SIZE (4 + 1)
#define KEY_COUNT (10000 * 10)

#define TABLE_SIZE (KEY_COUNT * 2)

struct Element;
struct ListNode;
struct HashTbl;

typedef struct Element ElementType;

typedef struct ListNode *Position;
typedef Position List;

typedef struct HashTbl *HashTable;
typedef size_t Index;
typedef Index TableSize;

struct Element {
    char data[KEY_SIZE];
};

struct ListNode {
	ElementType element;
	Position next;
};

struct HashTbl {
	TableSize tableSize;
	List* theListArray;
};

inline ElementType elementCreate(const char* str) {
    ElementType element;
    strncpy(element.data, str, KEY_SIZE - 1);
    element.data[KEY_SIZE - 1] = '\0';
    return element;
}

inline bool elementsAreEqual(const ElementType* elementPtrA, const ElementType* elementPtrB) {
    return !strncmp(elementPtrA->data, elementPtrB->data, KEY_SIZE - 1);
}

void hashTableInsert(const ElementType* keyPtr, HashTable hashTable);
void hashTableDelete(const ElementType* keyPtr, HashTable hashTable);
Position hashTableFind(const ElementType* keyPtr, HashTable hashTable);
HashTable hashTableCreate(TableSize tableSize);
void hashTableDestroy(HashTable hashTable);

void linkedListInsert(const ElementType* elementPtr, Position position, List list);
void linkedListDelete(const ElementType* elementPtr, List list);
Position linkedListFind(const ElementType* elementPtr, List list);
Position linkedListFindPrevious(const ElementType* elementPtr, List list);
List linkedListCreate();
void linkedListDestroy(List list);
List linkedListEmpty(List list);

inline bool linkedListIsEmpty(List list) {
    return list->next == NULL;
}

inline ElementType linkedListRetrieve(Position position) {
    return position->element;
}

static Index hashTableHash(const ElementType* keyPtr, TableSize tableSize);
static size_t linkedListSize(List list);
static void printLinkedList(List list);
static void printHashTable(HashTable hashTable);

static Index hashTableHash(const ElementType* keyPtr, TableSize tableSize) {
	TableSize hashVal = 0;

    TableSize dataIndex = 0;
	while (keyPtr->data[dataIndex] != '\0') {
		hashVal += (hashVal << 5) + keyPtr->data[dataIndex++];
	}
	return hashVal % tableSize;
}

// 不存放相同的 key
void hashTableInsert(const ElementType* keyPtr, HashTable hashTable) {
	Position pos = hashTableFind(keyPtr, hashTable);
    if (pos) {
        return;
    }

    Position newNode = malloc(sizeof(struct ListNode));
    if (!newNode) {
        fprintf(stderr, "No space for newNode!\n");
        exit(EXIT_FAILURE);
    }
    newNode->element = *keyPtr;

    List list = hashTable->theListArray[hashTableHash(keyPtr, hashTable->tableSize)];

    linkedListInsert(keyPtr, list, list);
}

Position hashTableFind(const ElementType* keyPtr, HashTable hashTable) {
    Position pos = linkedListFind(keyPtr, hashTable->theListArray[hashTableHash(keyPtr, hashTable->tableSize)]);
    if (pos) {
        return pos;
    }

    return NULL;
}

HashTable hashTableCreate(TableSize tableSize) {
	HashTable hashTable = malloc(sizeof(struct HashTbl));
    if (!hashTable) {
        fprintf(stderr, "No space for hashTable!\n");
        exit(EXIT_FAILURE);
    }
	hashTable->tableSize = tableSize;

    // ### 创建 Lists
    // 创建指向 lists 数组
	hashTable->theListArray = malloc(sizeof(List) * hashTable->tableSize);
    if (!hashTable->theListArray) {
        fprintf(stderr, "No space for hashTable->theListArray!\n");
        exit(EXIT_FAILURE);
    }

	// #### 分配表头
	for (Index i = 0; i < hashTable->tableSize; i++) {
		hashTable->theListArray[i] = malloc(sizeof(struct ListNode));
        if (!hashTable->theListArray[i]) {
            fprintf(stderr, "No space for hashTable->theListArray[i]!\n");
            exit(EXIT_FAILURE);
        }
		hashTable->theListArray[i]->next = NULL;
	}

	return hashTable;
}

void hashTableDelete(const ElementType* keyPtr, HashTable hashTable) {
    linkedListDelete(keyPtr, hashTable->theListArray[hashTableHash(keyPtr, hashTable->tableSize)]);
}

void hashTableDestroy(HashTable hashTable) {
    if (!hashTable || !hashTable->theListArray) {
        fprintf(stderr, "hashTable is NULL!\n");
        exit(EXIT_FAILURE);
    }

    for (Index i = 0; i < hashTable->tableSize; i++) {
        linkedListDestroy(hashTable->theListArray[i]);
    }
    free(hashTable);
}

// list 暂时不用
void linkedListInsert(const ElementType* elementPtr, Position position, List list) {
    Position newNode = malloc(sizeof(struct ListNode));
    if (!newNode) {
        fprintf(stderr, "No space for creating a node");
        exit(EXIT_FAILURE);
    }
    newNode->element = *elementPtr;

    newNode->next = position->next;
    position->next = newNode;
}

void linkedListDelete(const ElementType* elementPtr, List list) {
    Position prevPos = linkedListFindPrevious(elementPtr, list);

    if (prevPos) {
        Position curPos = prevPos->next;
        prevPos->next = curPos->next;
        free(curPos);
    }
}

Position linkedListFind(const ElementType* elementPtr, List list) {
    Position curPos = list->next;
    while (curPos) {
        if (elementsAreEqual(&curPos->element, elementPtr)) {
            return curPos;
        }
        curPos = curPos->next;
    }

    return curPos;
}

// 如果找不到则返回 NULL
Position linkedListFindPrevious(const ElementType* elementPtr, List list) {
    Position prePos = list;
    while (prePos->next) {
        if (elementsAreEqual(&prePos->next->element, elementPtr)) {
            return prePos;
        }

        prePos = prePos->next;
    }

    return prePos->next;
}

List linkedListCreate() {
    List list = malloc(sizeof(struct ListNode));
    if (!list) {
        fprintf(stderr, "No space for creating list!\n");
        exit(EXIT_FAILURE);
    }
    list->next = NULL;

    return list;
}

void linkedListDestroy(List list) {
    Position curPos = list;
    Position tmpPos;
    while (curPos) {
        tmpPos = curPos->next;
        free(curPos);
        curPos = tmpPos;
    }
}

List linkedListEmpty(List list) {
    Position curPos = list->next;
    list->next = NULL;
    Position tmpPos;
    while (curPos) {
        tmpPos = curPos->next;
        free(curPos);
        curPos = tmpPos;
    }
    return list;
}

static size_t linkedListSize(List list) {
    size_t size = 0;
    Position curPos = list->next;
    while (curPos) {
        size++;
        curPos = curPos->next;
    }

    return size;
}

static void printLinkedList(List list) {
    if (!list) {
        fprintf(stderr, "list is NULL!\n");
        exit(EXIT_FAILURE);
    }

    Position curPos = list->next;
    while (curPos) {
        printf("%s\t", curPos->element.data);
        curPos = curPos->next;
    }
    printf("\n");
}

static void printHashTable(HashTable hashTable) {
    if (!hashTable) {
        fprintf(stderr, "hashTable is NULL!\n");
        exit(EXIT_FAILURE);
    }

    for (Index i = 0; i < hashTable->tableSize; i++) {
        if (hashTable->theListArray[i]->next) {
            printf("theListArray[%d]: ", i);
            printLinkedList(hashTable->theListArray[i]);
        }
    }
}

void printStrArrays(char (*array)[KEY_SIZE], size_t n) {
    for (size_t i = 0; i < n; i++) {
        printf("%s\t", array[i]);
    }
    printf("\n");
}

void genRandomStrings(char (*outArray)[KEY_SIZE], size_t n, char lower, char upper) {
    srand(time(0));
    int tmpUpper = upper - lower + 1;
    int j;
    for (size_t i = 0; i < n; i++) {
        for (j = 0; j < KEY_SIZE - 1; j++) {
            outArray[i][j] = (char) (rand() % tmpUpper + lower);
        }
        outArray[i][j] = '\0';
    }
}

clock_t getTime() {
    clock_t t = clock();
    if (t == (clock_t)-1) {
        fprintf(stderr, "clock() failed\n");
        exit(EXIT_FAILURE);
    }
    return t;
}

// main.c
void TestHashTable() {
    char strArrays[KEY_COUNT][KEY_SIZE];
    genRandomStrings(strArrays, KEY_COUNT, 'A', 'Z');
    /* printStrArrays(strArrays, KEY_COUNT); */
    ElementType elementArray[KEY_COUNT];
    for (Index x = 0; x < KEY_COUNT; x++) {
        elementArray[x] = elementCreate(strArrays[x]);
    }

    HashTable hashTable = hashTableCreate(TABLE_SIZE);

    clock_t start, end, duration;
    start = getTime();
    for (Index i = 0; i < KEY_COUNT; i++) {
        hashTableInsert(&elementArray[i], hashTable);
    }
    /* printf("hashTable:\n"); */
    /* printHashTable(hashTable); */

    bool isSame = true;
    Position pos;
    for (Index j = 0; j < KEY_COUNT; j++) {
        if (!(pos = hashTableFind(&elementArray[j], hashTable))) {
            isSame = false;
            break;
        }
    }
    printf("isSame: %d\n", isSame);

    for (Index k = 0; k < KEY_COUNT; k++) {
        hashTableDelete(&elementArray[k], hashTable);
    }
    end = getTime();
    /* printf("hashTable:\n"); */
    /* printHashTable(hashTable); */
    // 取上限
    duration = ((end - start) - 1) / CLOCKS_PER_SEC + 1;
    printf("duration = %lfs\n", (double) duration);

    hashTableDestroy(hashTable);
}

int main() {
	TestHashTable();
	return 0;
}
```

### OpenAddressing

解决冲突的方法是开放定址法。有一个冲突解决方程，自变量是冲突次数，`(散列值 + 因变量) mod TableSize` 是将要插入的位置。

```c
// ### 说明
// 用平方探测法
// 删除用惰性删除

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <time.h>

#define KEY_SIZE (4 + 1)
#define KEY_COUNT (10000 * 10)
// 如果用平方探测，当表大小是素数，那么当表至少有一半为空时，总能插入一个新的元素。
#define TABLE_SIZE (KEY_COUNT * 2)

enum EntryStatusStruct;
struct Element;
struct HashEntry;
struct HashTbl;

typedef enum EntryStatusStruct EntryStatus;
typedef struct Element ElementType;
typedef struct HashEntry Cell;
typedef struct HashTbl *HashTable;
typedef size_t TableSize;
typedef TableSize Position;

struct Element {
    char data[KEY_SIZE];
};

enum EntryStatusStruct {
    empty,
    legitimate,
    deleted
};

struct HashEntry {
    ElementType element;
	EntryStatus status;
};

struct HashTbl {
	TableSize tableSize;
	TableSize size;
	Cell *theCellArray;
};

inline ElementType elementCreate(const char* str) {
    ElementType element;
    strncpy(element.data, str, KEY_SIZE - 1);
    element.data[KEY_SIZE - 1] = '\0';
    return element;
}

inline bool elementsAreEqual(const ElementType* elementPtrA, const ElementType* elementPtrB) {
    return !strncmp(elementPtrA->data, elementPtrB->data, KEY_SIZE - 1);
}

inline char* elementRetrieve(ElementType* elementPtr) {
    return elementPtr->data;
}

// 找到 key（包含 deleted key），如果没有找到则返回 key 可以插入的位置。注意：调用此函数会 rehash。
Position hashTableFind(const ElementType* keyPtr, HashTable hashTable);
void hashTableInsert(const ElementType* keyPtr, HashTable hashTable);
void hashTableDelete(const ElementType* keyPtr, HashTable hashTable);
HashTable hashTableCreate(TableSize tableSize);
void hashTableDestroy(HashTable hashTable);

static Position hashTableHash(const ElementType* keyPtr, TableSize tableSize);
static void hashTableReHash(HashTable hashTable);
static void printHashTable(HashTable hashTable);

inline Position hashTableDetect(TableSize collisionNum) {
	return collisionNum * collisionNum;
}

inline ElementType hashTableRetrieve(Position position, HashTable hashTable) {
    return hashTable->theCellArray[position].element;
}

static void printStrArrays(const char (*array)[KEY_SIZE], size_t n);
static void genRandomStrings(char (*outArray)[KEY_SIZE], size_t n, char lower, char upper);
static clock_t getTime();

static Position hashTableHash(const ElementType* keyPtr, TableSize tableSize) {
	TableSize hashVal = 0;

    TableSize dataIndex = 0;
	while (keyPtr->data[dataIndex] != '\0') {
		hashVal += (hashVal << 5) + keyPtr->data[dataIndex++];
	}
	return hashVal % tableSize;
}

Position hashTableFind(const ElementType* keyPtr, HashTable hashTable) {
    Position curPos = hashTableHash(keyPtr, hashTable->tableSize);
	TableSize collisionNum = 0;

    Position firstPos = curPos;
    int firstPosCount = 0;
    while (hashTable->theCellArray[curPos].status != empty \
            && !elementsAreEqual(&hashTable->theCellArray[curPos].element, keyPtr)) {
        collisionNum++;
        curPos = (firstPos + hashTableDetect(collisionNum)) % hashTable->tableSize;
        if (curPos == firstPos) {
            firstPosCount++;
        }
        if (firstPosCount > 1) {
            hashTableReHash(hashTable);

            // 继续 find
            curPos = hashTableFind(keyPtr, hashTable);
            break;
        }
    }

	return curPos;
}

// 不插入重复的 key
void hashTableInsert(const ElementType* keyPtr, HashTable hashTable) {
    Position pos = hashTableFind(keyPtr, hashTable);
    if (hashTable->theCellArray[pos].status != legitimate) {
        hashTable->theCellArray[pos].element = *keyPtr;
        hashTable->theCellArray[pos].status = legitimate;
        hashTable->size++;
    }
}

void hashTableDelete(const ElementType* keyPtr, HashTable hashTable) {
    Position pos = hashTableFind(keyPtr, hashTable);
    if (hashTable->theCellArray[pos].status == legitimate) {
        hashTable->theCellArray[pos].status = deleted;
        hashTable->size--;
    }
}

// 不知是不是 bug，声明为 inline 时，编译器无法找到该函数。
void hashTableDestroy(HashTable hashTable) {
    free(hashTable->theCellArray);
    free(hashTable);
}

HashTable hashTableCreate(TableSize tableSize) {
    HashTable hashTable = malloc(sizeof(struct HashTbl));
    if (!hashTable) {
        fprintf(stderr, "No space for creating hashTable!\n");
        exit(EXIT_FAILURE);
    }
    hashTable->theCellArray = malloc(sizeof(struct HashEntry) * tableSize);
    if (!hashTable->theCellArray) {
        fprintf(stderr, "No space for creating hashTable->theCellArray!\n");
        exit(EXIT_FAILURE);
    }

    hashTable->tableSize = tableSize;
    hashTable->size = 0;
    for (Position i = 0; i < tableSize; i++) {
        hashTable->theCellArray[i].status = empty;
    }

    return hashTable;
}

static void hashTableReHash(HashTable hashTable) {
    Cell* oldCellArray = hashTable->theCellArray;
    TableSize oldTableSize = hashTable->tableSize;

    TableSize newTableSize = hashTable->tableSize * 2;
    Cell* newCellArray = malloc(sizeof(struct HashEntry) * newTableSize);
    if (!newCellArray) {
        fprintf(stderr, "No space for newCellArray!\n");
        exit(EXIT_FAILURE);
    }
    for (Position i; i < newTableSize; i++) {
        newCellArray->status = empty;
    }
    hashTable->tableSize = newTableSize;
    hashTable->size = 0;
    hashTable->theCellArray = newCellArray;

	for (Position i = 0; i < oldTableSize; i++) {
        // 不保留 deleted
		if (oldCellArray[i].status == legitimate) {
            hashTableInsert(&oldCellArray[i].element, hashTable);
        }
	}
    free(oldCellArray);
}

static void printHashTable(HashTable hashTable) {
    printf("Num\t\t\tElement\t\t\tInfo\n");
    for (Position i = 0; i < hashTable->tableSize; i++) {
        if (hashTable->theCellArray[i].status == legitimate) {
            printf("%lu\t\t\t%s\t\t\t%s\n", i, elementRetrieve(&hashTable->theCellArray[i].element), "legitimate");
        } else if (hashTable->theCellArray[i].status == deleted) {
            printf("%lu\t\t\t%s\t\t\t%s\n", i, elementRetrieve(&hashTable->theCellArray[i].element), "deleted");
        } else {    // empty
        }
    }
}

static void printStrArrays(const char (*array)[KEY_SIZE], size_t n) {
    for (size_t i = 0; i < n; i++) {
        printf("%s\t", array[i]);
    }
    printf("\n");
}

static void genRandomStrings(char (*outArray)[KEY_SIZE], size_t n, char lower, char upper) {
    srand(time(0));
    int tmpUpper = upper - lower + 1;
    int j;
    for (size_t i = 0; i < n; i++) {
        for (j = 0; j < KEY_SIZE - 1; j++) {
            outArray[i][j] = (char) (rand() % tmpUpper + lower);
        }
        outArray[i][j] = '\0';
    }
}

static clock_t getTime() {
    clock_t t = clock();
    if (t == (clock_t)-1) {
        fprintf(stderr, "clock() failed\n");
        exit(EXIT_FAILURE);
    }
    return t;
}

static void testHashTable() {
    char strArrays[KEY_COUNT][KEY_SIZE];
    genRandomStrings(strArrays, KEY_COUNT, 'A', 'Z');
    /* printStrArrays(strArrays, KEY_COUNT); */
    ElementType elementArray[KEY_COUNT];
    for (Position x = 0; x < KEY_COUNT; x++) {
        elementArray[x] = elementCreate(strArrays[x]);
    }

    /* HashTable hashTable = hashTableCreate(TABLE_SIZE); */
    HashTable hashTable = hashTableCreate(2);

    clock_t start, end, duration;
    start = getTime();
    for (Position i = 0; i < KEY_COUNT; i++) {
        hashTableInsert(&elementArray[i], hashTable);
    }
    /* printf("hashTable:\n"); */
    /* printHashTable(hashTable); */

    bool isSame = true;
    Position pos;
    for (Position j = 0; j < KEY_COUNT; j++) {
        pos = hashTableFind(&elementArray[j], hashTable);
        if (hashTable->theCellArray[pos].status != legitimate) {
            isSame = false;
            break;
        }
    }
    printf("isSame: %d\n", isSame);

    for (Position k = 0; k < KEY_COUNT; k++) {
        hashTableDelete(&elementArray[k], hashTable);
    }
    end = getTime();
    /* printf("hashTable:\n"); */
    /* printHashTable(hashTable); */
    // 取上限
    duration = ((end - start) - 1) / CLOCKS_PER_SEC + 1;
    printf("duration = %lfs\n", (double) duration);

    hashTableDestroy(hashTable);
}

int main() {
	testHashTable();
	return 0;
}
```

## Stack, Queue

### Stack

#### 用数组实现

```c
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <time.h>

#define ARRAY_SIZE (10000 * 10)

typedef int ElementType;

struct Stack {
    int capacity;
    int size;
    ElementType* data;
};

void stackPush(const ElementType* elementPtr, struct Stack* stackPtr);
ElementType stackPop(struct Stack* stackPtr);
struct Stack* stackCreate(int capacity);
void stackDestroy(struct Stack* stackPtr);
ElementType stackTop(struct Stack* stackPtr);

inline bool stackIsEmpty(struct Stack* stackPtr) {
    return stackPtr->size == 0;
}

static inline int stackSize(struct Stack* stackPtr);

struct Stack* stackCreate(int capacity) {
    struct Stack* stackPtr = malloc(sizeof(struct Stack));
    if (!stackPtr) {
        fprintf(stderr, "No space for creating stack\n");
        exit(EXIT_FAILURE);
    }

    stackPtr->data = malloc(sizeof(ElementType) * capacity);
    if (!stackPtr->data) {
        fprintf(stderr, "No space for stack data\n");
        exit(EXIT_FAILURE);
    }

    stackPtr->size = 0;
    stackPtr->capacity = capacity;

    return stackPtr;
}

void stackDestroy(struct Stack* stackPtr) {
    free(stackPtr->data);
    free(stackPtr);
}

void stackPush(const ElementType* elementPtr, struct Stack* stackPtr) {
    if (stackPtr->size == stackPtr->capacity) {
        stackPtr->capacity = stackPtr->size * 2;
        ElementType* newData = malloc(sizeof(ElementType) * stackPtr->capacity);
        if (!newData) {
            fprintf(stderr, "No space for newData\n");
            exit(EXIT_FAILURE);
        }

        for (int i = 0; i < stackPtr->size; i++) {
            newData[i] = stackPtr->data[i];
        }
        free(stackPtr->data);
        stackPtr->data = newData;
    }

    stackPtr->data[stackPtr->size++] = *elementPtr;
}

ElementType stackPop(struct Stack* stackPtr) {
    if (stackPtr->size <= 0) {
        fprintf(stderr, "Stack is empty!\n");
        exit(EXIT_FAILURE);
    }

    ElementType topElement = stackTop(stackPtr);
    stackPtr->size--;
    return topElement;
}

ElementType stackTop(struct Stack* stackPtr) {
    if (!stackPtr->size) {
        fprintf(stderr, "Stack is empty!\n");
        exit(EXIT_FAILURE);
    }

    return stackPtr->data[stackPtr->size - 1];
}

static inline int stackSize(struct Stack* stackPtr) {
    return stackPtr->size;
}

void printArray(const int* array, int n) {
    for (int i = 0; i < n; i++) {
        printf("%d\t", array[i]);
    }
    printf("\n");
}

void genRandomNums(int* outArray, int n, int lower, int upper) {
    srand(time(0));
    int tmpUpper = upper - lower + 1;
    for (int i = 0; i < n; i++) {
        outArray[i] = rand() % tmpUpper + lower;
    }
}

clock_t getTime() {
    clock_t t = clock();
    if (t == (clock_t)-1) {
        fprintf(stderr, "clock() failed\n");
        exit(EXIT_FAILURE);
    }
    return t;
}

int main() {
    ElementType array[ARRAY_SIZE];
    genRandomNums(array, ARRAY_SIZE, 1, ARRAY_SIZE);

    clock_t start, end, duration;
    struct Stack* stackPtr = stackCreate(20);
    start = getTime();
    for (int i = 0; i < ARRAY_SIZE; i++) {
        stackPush(&array[i], stackPtr);
    }
    printf("size of stack: %d\n", stackSize(stackPtr));

    ElementType tmpArray[ARRAY_SIZE];
    for (int j = 0; j < ARRAY_SIZE; j++) {
        tmpArray[j] = stackPop(stackPtr);
    }
    end = getTime();
    printf("size of stack: %d\n", stackSize(stackPtr));
    // 取上限
    duration = ((end - start) - 1) / CLOCKS_PER_SEC + 1;
    printf("duration = %lfs\n", (double) duration);

    bool isSame = true;
    for (int k = 0; k < ARRAY_SIZE; k++) {
        if (tmpArray[k] != array[ARRAY_SIZE - 1 - k]) {
            isSame = false;
            break;
        }
    }
    printf("isSame: %d\n", isSame);

    stackDestroy(stackPtr);

    return 0;

}
```

#### 用链表实现

```c
// ### 说明
// 链表保留头节点

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <time.h>

#define ARRAY_SIZE (10000 * 10)

typedef int ElementType;

struct Node {
    ElementType element;
    struct Node* next;
};

struct Node* stackCreate();
void stackDestroy(struct Node* stackPtr);
void stackEmpty(struct Node* stackPtr);
ElementType stackTop(const struct Node* stackPtr);

inline bool stackIsEmpty(const struct Node* stackPtr) {
    return stackPtr->next == NULL;
}

inline void stackPush(const ElementType* elementPtr, struct Node* stackPtr) {
    struct Node* newNodePtr = malloc(sizeof(struct Node));
    if (!newNodePtr) {
        fprintf(stderr, "No space for newNode!\n");
        exit(EXIT_FAILURE);
    }
    newNodePtr->element = *elementPtr;

    newNodePtr->next = stackPtr->next;
    stackPtr->next = newNodePtr;
}

inline ElementType stackPop(struct Node* stackPtr) {
    if (stackIsEmpty(stackPtr)) {
        fprintf(stderr, "The stack is empty!\n");
        exit(EXIT_FAILURE);
    }

    struct Node* tmpNodePtr = stackPtr->next;
    stackPtr->next = tmpNodePtr->next;

    ElementType element = tmpNodePtr->element;
    free(tmpNodePtr);
    return element;
}

static int stackSize(const struct Node* stackPtr);

struct Node* stackCreate() {
    struct Node* stackPtr = malloc(sizeof(struct Node));
    if (!stackPtr) {
        fprintf(stderr, "No space for creating stack!\n");
        exit(EXIT_FAILURE);
    }
    stackPtr->next = NULL;

    return stackPtr;
}

void stackDestroy(struct Node* stackPtr) {
    stackEmpty(stackPtr);
    free(stackPtr);
}

void stackEmpty(struct Node* stackPtr) {
    struct Node* tmpNodePtr = stackPtr->next;
    while (tmpNodePtr) {
        stackPtr->next = tmpNodePtr->next;
        free(tmpNodePtr);
    }
}

ElementType stackTop(const struct Node* stackPtr) {
    if (stackIsEmpty(stackPtr)) {
        fprintf(stderr, "The stack is empty!\n");
        exit(EXIT_FAILURE);
    }
    return stackPtr->next->element;
}

static int stackSize(const struct Node* stackPtr) {
    int size = 0;
    const struct Node* tmpNodePtr = stackPtr;
    while ((tmpNodePtr = tmpNodePtr->next)) {
        size++;
    }

    return size;
}

void printArray(int* array, int n) {
    for (int i = 0; i < n; i++) {
        printf("%d\t", array[i]);
    }
    printf("\n");
}

void genRandomNums(int* outArray, int n, int lower, int upper) {
    srand(time(0));
    int tmpUpper = upper - lower + 1;
    for (int i = 0; i < n; i++) {
        outArray[i] = rand() % tmpUpper + lower;
    }
}

clock_t getTime() {
    clock_t t = clock();
    if (t == (clock_t)-1) {
        fprintf(stderr, "clock() failed\n");
        exit(EXIT_FAILURE);
    }
    return t;
}

int main() {
    ElementType array[ARRAY_SIZE];
    genRandomNums(array, ARRAY_SIZE, 1, ARRAY_SIZE);

    clock_t start, end, duration;
    struct Node* stackPtr = stackCreate();
    start = getTime();
    for (int i = 0; i < ARRAY_SIZE; i++) {
        stackPush(&array[i], stackPtr);
    }
    printf("size of stack: %d\n", stackSize(stackPtr));

    ElementType tmpArray[ARRAY_SIZE];
    for (int j = 0; j < ARRAY_SIZE; j++) {
        tmpArray[j] = stackPop(stackPtr);
    }
    end = getTime();
    printf("size of stack: %d\n", stackSize(stackPtr));
    // 取上限
    duration = ((end - start) - 1) / CLOCKS_PER_SEC + 1;
    printf("duration = %lfs\n", (double) duration);

    bool isSame = true;
    for (int k = 0; k < ARRAY_SIZE; k++) {
        if (tmpArray[k] != array[ARRAY_SIZE - 1 - k]) {
            isSame = false;
            break;
        }
    }
    printf("isSame: %d\n", isSame);

    stackDestroy(stackPtr);

    return 0;
}
```

### Queue

#### 用数组实现

```c
// ### 说明
// 有 size 字段
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <time.h>

#define ARRAY_SIZE (10000 * 10)

typedef int ElementType;

struct Queue {
    int capacity;
    int size;
    int front;
    int rear;
    ElementType* data;
};

void queueEnqueue(const ElementType* elementPtr, struct Queue* queuePtr);
ElementType queueDequeue(struct Queue* queuePtr);
struct Queue* queueCreate(int capacity);
void queueDestroy(struct Queue* queuePtr);
void queueEmpty(struct Queue* queuePtr);

inline bool queueIsEmpty(const struct Queue* queuePtr) {
    return queuePtr->size == 0;
}

inline ElementType queueFront(struct Queue* queuePtr) {
    if (queueIsEmpty(queuePtr)) {
        fprintf(stderr, "The queue is empty!\n");
        exit(EXIT_FAILURE);
    }

    return queuePtr->data[queuePtr->front];
}

inline ElementType queueBack(struct Queue* queuePtr) {
    if (queueIsEmpty(queuePtr)) {
        fprintf(stderr, "The queue is empty!\n");
        exit(EXIT_FAILURE);
    }

    return queuePtr->data[queuePtr->rear];
}

static inline bool queueIsFull(const struct Queue* queuePtr);
static inline int queueSucc(int index, struct Queue* queuePtr);

static int queueSize(const struct Queue* queuePtr);

void queueEnqueue(const ElementType* elementPtr, struct Queue* queuePtr) {
    if (queueIsFull(queuePtr)) {
        int newCapacity = queuePtr->capacity * 2;
        ElementType* newData = malloc(sizeof(ElementType) * newCapacity);
        if (!newData) {
            fprintf(stderr, "No space for newData!\n");
            exit(EXIT_FAILURE);
        }

        for (int i = 0; i < queuePtr->size; i++) {
            newData[i] = queueDequeue(queuePtr);
        }
        free(queuePtr->data);
        queuePtr->data = newData;
        queuePtr->capacity = newCapacity;
        queuePtr->front = 0;
        queuePtr->rear = queuePtr->size - 1;
    }

    queuePtr->rear = queueSucc(queuePtr->rear, queuePtr);
    queuePtr->data[queuePtr->rear] = *elementPtr;
    queuePtr->size++;
}

ElementType queueDequeue(struct Queue* queuePtr) {
    if (queueIsEmpty(queuePtr)) {
        fprintf(stderr, "The queue is empty!\n");
        exit(EXIT_FAILURE);
    }

    ElementType frontElement = queueFront(queuePtr);
    queuePtr->front = queueSucc(queuePtr->front, queuePtr);
    return frontElement;
}

static inline bool queueIsFull(const struct Queue* queuePtr) {
    return queuePtr->size == queuePtr->capacity;
}

static inline int queueSucc(int index, struct Queue* queuePtr) {
    if (++index == queuePtr->capacity) {
        index = 0;
    }
    return index;
}

void queueEmpty(struct Queue* queuePtr) {
    queuePtr->size = 0;
    queuePtr->rear = 0;
    queuePtr->front = 1;
}

struct Queue* queueCreate(int capacity) {
    struct Queue* queuePtr = malloc(sizeof(struct Queue));
    if (!queuePtr) {
        fprintf(stderr, "No space for creating queue!\n");
        exit(EXIT_FAILURE);
    }

    queuePtr->data = malloc(sizeof(ElementType) * capacity);
    if (!queuePtr->data) {
        fprintf(stderr, "No space for queue data!\n");
        exit(EXIT_FAILURE);
    }
    queuePtr->capacity = capacity;

    queueEmpty(queuePtr);
    return queuePtr;
}

void queueDestroy(struct Queue* queuePtr) {
    free(queuePtr->data);
    free(queuePtr);
}

static inline int queueSize(const struct Queue* queuePtr) {
    return queuePtr->size;
}

void printArray(const int* array, int n) {
    for (int i = 0; i < n; i++) {
        printf("%d\t", array[i]);
    }
    printf("\n");
}

void genRandomNums(int* outArray, int n, int lower, int upper) {
    srand(time(0));
    int tmpUpper = upper - lower + 1;
    for (int i = 0; i < n; i++) {
        outArray[i] = rand() % tmpUpper + lower;
    }
}

clock_t getTime() {
    clock_t t = clock();
    if (t == (clock_t)-1) {
        fprintf(stderr, "clock() failed\n");
        exit(EXIT_FAILURE);
    }
    return t;
}

int main() {
    ElementType array[ARRAY_SIZE];
    genRandomNums(array, ARRAY_SIZE, 1, ARRAY_SIZE);

    clock_t start, end, duration;
    struct Queue* queuePtr = queueCreate(20);
    start = getTime();
    for (int i = 0; i < ARRAY_SIZE; i++) {
        queueEnqueue(&array[i], queuePtr);
    }
    printf("size of queue: %d\n", queueSize(queuePtr));

    ElementType tmpArray[ARRAY_SIZE];
    for (int j = 0; j < ARRAY_SIZE; j++) {
        tmpArray[j] = queueDequeue(queuePtr);
    }
    end = getTime();
    printf("size of queue: %d\n", queueSize(queuePtr));
    // 取上限
    duration = ((end - start) - 1) / CLOCKS_PER_SEC + 1;
    printf("duration = %lfs\n", (double) duration);

    bool isSame = true;
    for (int k = 0; k < ARRAY_SIZE; k++) {
        if (array[k] != tmpArray[k]) {
            isSame = false;
            break;
        }
    }
    printf("isSame: %d\n", isSame);

    queueDestroy(queuePtr);

    return 0;
}
```

#### 用链表实现

```c
// ### 说明
// 链表不保留头节点

#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <time.h>

#define ARRAY_SIZE (10000 * 10)

typedef int ElementType;

struct Node {
    ElementType element;
    struct Node* next;
};

struct Queue {
    struct Node* front;
    struct Node* rear;
    int size;
};

void queueEnqueue(const ElementType* elementPtr, struct Queue* queuePtr);
ElementType queueDequeue(struct Queue* queuePtr);
struct Queue* queueCreate();
void queueDestroy(struct Queue* queuePtr);

inline bool queueIsEmpty(const struct Queue* queuePtr) {
    return queuePtr->size == 0;
}

inline ElementType queueFront(struct Queue* queuePtr) {
    if (queueIsEmpty(queuePtr)) {
        fprintf(stderr, "The queue is empty!\n");
        exit(EXIT_FAILURE);
    }

    return queuePtr->front->element;
}

inline ElementType queueBack(struct Queue* queuePtr) {
    if (queueIsEmpty(queuePtr)) {
        fprintf(stderr, "The queue is empty!\n");
        exit(EXIT_FAILURE);
    }

    return queuePtr->rear->element;
}

void queueEmpty(struct Queue* queuePtr);

static int queueSize(const struct Queue* queuePtr);

void queueEnqueue(const ElementType* elementPtr, struct Queue* queuePtr) {
    struct Node* newNodePtr = malloc(sizeof(struct Node));
    if (!newNodePtr) {
        fprintf(stderr, "No space for new Node!\n");
        exit(EXIT_FAILURE);
    }
    newNodePtr->element = *elementPtr;
    newNodePtr->next = NULL;

    if (!queuePtr->size) {
        queuePtr->rear = newNodePtr;
        queuePtr->front = newNodePtr;
    } else {
        queuePtr->rear->next = newNodePtr;
        queuePtr->rear = newNodePtr;
    }
    queuePtr->size++;
}

ElementType queueDequeue(struct Queue* queuePtr) {
    if (queueIsEmpty(queuePtr)) {
        fprintf(stderr, "The queue is empty!\n");
        exit(EXIT_FAILURE);
    }

    struct Node* tmpNode = queuePtr->front;
    queuePtr->front = tmpNode->next;
    queuePtr->size--;

    ElementType element = tmpNode->element;
    free(tmpNode);
    return element;
}

struct Queue* queueCreate() {
    struct Queue* queuePtr = malloc(sizeof(struct Queue));
    if (!queuePtr) {
        fprintf(stderr, "No space for creating queue!\n");
        exit(EXIT_FAILURE);
    }
    queuePtr->front = queuePtr->rear = NULL;
    queuePtr->size = 0;
    return queuePtr;
}

void queueDestroy(struct Queue* queuePtr) {
    struct Node* tmpNode;
    while (queuePtr->front) {
        tmpNode = queuePtr->front;
        queuePtr->front = queuePtr->front->next;
        free(tmpNode);
    }
    free(queuePtr);
}

void queueEmpty(struct Queue* queuePtr) {
    struct Node* tmpNode;
    while (queuePtr->front) {
        tmpNode = queuePtr->front;
        queuePtr->front = queuePtr->front->next;
        free(tmpNode);
    }
    queuePtr->rear = NULL;
    queuePtr->size = 0;
}

static int queueSize(const struct Queue* queuePtr) {
    return queuePtr->size;
}

void printArray(const int* array, int n) {
    for (int i = 0; i < n; i++) {
        printf("%d\t", array[i]);
    }
    printf("\n");
}

void genRandomNums(int* outArray, int n, int lower, int upper) {
    srand(time(0));
    int tmpUpper = upper - lower + 1;
    for (int i = 0; i < n; i++) {
        outArray[i] = rand() % tmpUpper + lower;
    }
}

clock_t getTime() {
    clock_t t = clock();
    if (t == (clock_t)-1) {
        fprintf(stderr, "clock() failed\n");
        exit(EXIT_FAILURE);
    }
    return t;
}

int main() {
    ElementType array[ARRAY_SIZE];
    genRandomNums(array, ARRAY_SIZE, 1, ARRAY_SIZE);

    clock_t start, end, duration;
    struct Queue* queuePtr = queueCreate();
    start = getTime();
    for (int i = 0; i < ARRAY_SIZE; i++) {
        queueEnqueue(&array[i], queuePtr);
    }
    printf("size of queue: %d\n", queueSize(queuePtr));

    ElementType tmpArray[ARRAY_SIZE];
    for (int j = 0; j < ARRAY_SIZE; j++) {
        tmpArray[j] = queueDequeue(queuePtr);
    }
    end = getTime();
    printf("size of queue: %d\n", queueSize(queuePtr));
    // 取上限
    duration = ((end - start) - 1) / CLOCKS_PER_SEC + 1;
    printf("duration = %lfs\n", (double) duration);

    bool isSame = true;
    for (int k = 0; k < ARRAY_SIZE; k++) {
        if (array[k] != tmpArray[k]) {
            isSame = false;
            break;
        }
    }
    printf("isSame: %d\n", isSame);

    queueDestroy(queuePtr);

    return 0;
}
```

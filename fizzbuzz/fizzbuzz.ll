@.str1 = private unnamed_addr constant [13 x i8] c"hello world\0A\00", align 1
@.str2 = private unnamed_addr constant [13 x i8] c"anoher hell\0A\00", align 1
@.str3 = private unnamed_addr constant [18 x i8] c"values are equal\0A\00", align 1
@.str4 = private unnamed_addr constant [22 x i8] c"values not are equal\0A\00", align 1
@.str5 = private unnamed_addr constant [19 x i8] c"current value: %d\0A\00", align 1
@.fizz_str = private unnamed_addr constant [10 x i8] c"%d: fizz\0A\00", align 1
@.buzz_str = private unnamed_addr constant [10 x i8] c"%d: buzz\0A\00", align 1
@.fizzbuzz_str = private unnamed_addr constant [14 x i8] c"%d: fizzbuzz\0A\00", align 1
@.nothing_str = private unnamed_addr constant [5 x i8] c"%d:\0A\00", align 1


define dso_local i32 @main() #0 {
  ; upper loop bound exclusive
  %loop_bound_ptr = alloca i32
  store i32 100, i32* %loop_bound_ptr
  %loop_bound_val = load i32, i32* %loop_bound_ptr

  ; loop init value
  %loop_init_ptr = alloca i32
  store i32 1, i32* %loop_init_ptr

  ; start looping
  br label %should_loop

should_loop:
  %loop_init_val = load i32, i32* %loop_init_ptr
  %should_exit = icmp eq i32 %loop_init_val, %loop_bound_val
  br i1 %should_exit, label %exit, label %loop_block

exit:
  ret i32 0

loop_block:
  %loop_init_tmp_val = load i32, i32* %loop_init_ptr
  %loop_init_tmp_incremented = add nsw i32 %loop_init_tmp_val, 1
  store i32 %loop_init_tmp_incremented, i32* %loop_init_ptr

  %mod_3 = srem i32 %loop_init_tmp_val, 3
  %mod_5 = srem i32 %loop_init_tmp_val, 5
  br label %l_is_mod_3_and_5

l_is_mod_3:
  ; compute modulo 3 (fizz)
  %is_mod_3 = icmp eq i32 %mod_3, 0
  br i1 %is_mod_3, label %l_print_is_mod_3, label %l_is_mod_5

l_is_mod_5:
  ; compute modulo 5 (buzz)
  %is_mod_5 = icmp eq i32 %mod_5, 0
  br i1 %is_mod_5, label %l_print_is_mod_5, label %l_print_no_fizzbuzz

l_is_mod_3_and_5:
  ; compute module 3 and 5
  %is_mod_3_t = icmp eq i32 %mod_3, 0
  %is_mod_5_t = icmp eq i32 %mod_5, 0
  %mod_3_and_5 = and i1 %is_mod_3_t, %is_mod_5_t
  %is_mod_3_and_5 = icmp eq i1 %mod_3_and_5, 1
  br i1 %is_mod_3_and_5, label %l_print_is_mod_3_mod_5, label %l_is_mod_3

l_print_is_mod_3:
  %pr_mod_3 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.fizz_str, i64 0, i64 0), i32 noundef %loop_init_tmp_val)
  br label %should_loop

l_print_is_mod_5:
  %pr_mod_5 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.buzz_str, i64 0, i64 0), i32 noundef %loop_init_tmp_val)
  br label %should_loop

l_print_is_mod_3_mod_5:
  %pr_mod_3_and_5 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @.fizzbuzz_str, i64 0, i64 0), i32 noundef %loop_init_tmp_val)
  br label %should_loop

l_print_no_fizzbuzz:
  %pr_no_fizzbuzz = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.nothing_str, i64 0, i64 0), i32 noundef %loop_init_tmp_val)
  br label %should_loop
}


declare i32 @printf(i8* noundef, ...) #1

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

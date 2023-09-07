MLX				=	mlx
MLX_DIR			=	minilibx-linux

LIB				=	mlxge
TEST_TARGET		=	test

CFLAGS			=	

CC				=	cc

SRC_DIR			=	srcs
INC_DIR			=	includes

TEST_SRC_DIR	=	test_srcs
TEST_INC_DIR	=	test_srcs

FILES			=	\
					main.c	\

SRCS			=	$(addprefix $(SRC_DIR)/,$(FILES))
OBJS			=	$(SRCS:%.c=%.o)

TEST_FILES		=	\
					main.c	\

TEST_SRCS		=	$(addprefix $(TEST_SRC_DIR)/,$(TEST_FILES))
TEST_OBJS		=	$(TEST_SRCS:%.c=%.o)

.PHONY: all clean fclean re norminette test

all: lib$(LIB).a

clean:
	rm -f $(OBJS) $(TEST_OBJS)

fclean: clean
	rm -f lib$(LIB).a
	rm -f $(TEST_TARGET)

re: fclean all

norminette:
	norminette $(SRC_DIR) $(INC_DIR)

runtest: $(TEST_TARGET)
	./$(TEST_TARGET)

$(MLX_DIR)/lib$(MLX).a:
	git submodule init $(MLX_DIR)
	git submodule update $(MLX_DIR)
	$(MAKE) -C $(MLX_DIR)

$(TEST_TARGET): lib$(LIB).a $(TEST_OBJS)
	$(CC) -o $@ $(TEST_OBJS) -L. -l$(LIB)

lib$(LIB).a: $(MLX_DIR)/lib$(MLX).a $(OBJS)
	ar rcs $@ $(OBJS)

%.o: %.c
	$(CC) -c -o $@ $< -I$(INC_DIR) $(CFLAGS)
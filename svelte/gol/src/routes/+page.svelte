<script lang="ts">
  import { onMount } from 'svelte';
  import * as R from 'ramda';

  function get_board(width: number, height: number) {
    return Array.from({ length: width }, () => Array.from({ length: height }, () => false));
  }

  function get_random_board(chance: number, board: boolean[][]) {
    const size = board.length * board[0].length;
    const num = Math.floor(size * chance);
    return R.pipe(R.range(0), R.reduce(add_random_cell, board))(num);
  }

  function add_random_cell(board: boolean[][]): boolean[][] {
    const x = Math.floor(Math.random() * board.length);
    const y = Math.floor(Math.random() * board[0].length);
    if (board[x][y]) {
      return add_random_cell(board);
    } else {
      return R.update(x, R.update(y, true, board[x]), board);
    }
  }

  function get_live_neighbors(board: boolean[][], x: number, y: number) {
    const neighbors = [];
    for (let i = -1; i <= 1; i++) {
      for (let j = -1; j <= 1; j++) {
        if (i === 0 && j === 0) {
          continue;
        }
        const x1 = x + i;
        const y1 = y + j;
        if (x1 >= 0 && x1 < board.length && y1 >= 0 && y1 < board[0].length && board[x1][y1]) {
          neighbors.push(board[x1][y1]);
        }
      }
    }

    return neighbors.length;
  }

	function get_next_state(board: boolean[][], x: number, y: number) {
		const live_neighbors = get_live_neighbors(board, x, y);
		if (board[x][y]) {
			return live_neighbors === 2 || live_neighbors === 3;
		} else {
			return live_neighbors === 3;
		}
	}

	function get_next_board(board: boolean[][]) {
		return board.map((row, x) => row.map((cell, y) => get_next_state(board, x, y)));
	}

  function draw_board(board: boolean[][]) {
    let ctx = canvas.getContext('2d');
    if (ctx) {
      ctx.beginPath();
      ctx.lineWidth = 6;
      ctx.strokeStyle = 'red';
      // Iterate over the board and draw a rectangle for each cell
      board.forEach((row, x) => {
        row.forEach((cell, y) => {
          if (cell) {
            ctx!.fillRect(x * 10, y * 10, 10, 10);
          }
        });
      });

      ctx.stroke();
    }
  }

  function clear_board() {
    let ctx = canvas.getContext('2d');
    if (ctx) {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
    }
  }

  let canvas: HTMLCanvasElement;

  onMount(() => {
    console.log('mounted');

    let board = R.pipe(get_board, R.partial(get_random_board, [0.2]))(10, 10);

    console.log(board);

    draw_board(board);

    setInterval(() => {
			clear_board();
			board = get_next_board(board);
			draw_board(board);
		}, 1000);
  });
</script>

<h1>Welcome to SvelteKit</h1>
<p>Visit <a href="https://kit.svelte.dev">kit.svelte.dev</a> to read the documentation</p>
<canvas bind:this={canvas} width="100" height="100" style="border:1px solid #000000;" />

<?php

use App\Temps;
use Illuminate\Database\Seeder;

class TempTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $temp = new Temps();
        $temp->temp            = '21';
        $temp->air             = '4';
        $temp->save();
    }
}

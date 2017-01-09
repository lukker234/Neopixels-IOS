php artisan db:seed --class=UserTableSeeder<?php

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UsersTableSeeder extends Seeder
{
    public function run()
    {
        \App\User::create([
            'name' => 'Administrator',
            'email' => 'luc.daalmeijer@indicia.nl',
            'password' => Hash::make('Abcd_1234')
        ]);
    }
}

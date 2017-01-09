<?php

use App\Role;
use Illuminate\Database\Seeder;

class RolesTableSeeder extends Seeder
{
    public function run()
    {
        $owner = new Role();
        $owner->name            = 'admin';
        $owner->display_name    = 'Administrator';
        $owner->description     = 'Administrator mag alle data bekijken in de app';
        $owner->save();
    }
}
